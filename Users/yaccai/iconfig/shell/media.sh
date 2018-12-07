#!/bin/zsh
# coding:utf-8

yixiu () {
    tmp=`mktemp`
    purl="$1"
    while true; do
        curl "$purl" -s > $tmp
        ~/iconfig/exe/transCode.sh -d $tmp
        title=~/Downloads/`cat $tmp | ggrep -oP "(?<=<title>)[^(<]*"`
        [[ -d "$title" ]] || mkdir "$title"
        cat $tmp | ggrep -oP 'http://[a-z0-9\/]*.yixiu8.com:8080/picture/[a-z0-9\/]*\.jpg' | while read p; do
            name=`basename "$p"`
            printf "pull %8s  -- >  %s\n" "$name" "$p"
            curl -s --connect-timeout 5 -m 20 "$p" > "$title/$name"
            if [[ $? -ne 0 ]]; then
                echo "    timeout, curl $p > $title/$name"
                curl -s "$p" > "$title/$name"
            fi
        done

        next=`cat $tmp | ggrep -oP "(?<=<a href=')[^<>]*(?='>下一页)"` # 最后是#
        if [[ "$#next" -lt 3 ]]; then
            bakd=/Volumes/Bak/Picture/Model/Other
            mkdir -p "$bakd" &>/dev/null && cp -rf "$title" "$bakd"
            echo "完"
            break
        else
            purl="$(dirname $1)/$next"
        fi
    done
}

get () {
    cd ~/Downloads
    you-get           --timeout 10 "$1" && exit
    youtube-dl --socket-timeout 10 "$1" && exit

    you-get       --socks-proxy 127.0.0.1:1086 --timeout 10 "$1" && exit
    youtube-dl --proxy socks5://127.0.0.1:1086 --timeout 10 "$1" && exit
}


if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  "/\"[a-zA-Z\_\-\+]+\" \)/{print $1}" | sed "s/\"//g; s/)//g"
    exit
fi

case "$1" in
    "flush" )
        aria2c -c -x 10 https://mirrors.aliyun.com/ubuntu-releases/xenial/ubuntu-16.04.5-server-i386.iso
        ;;
    "yixiu" )
        yixiu "${@:2}"
        ;;
    "get" )
        get "${@:2}"
        ;;
    "captureVideo" )
        pid=`pgrep videosnap`
        [[ -z "$pid" ]] || kill -9 "$pid"
        ~/iconfig/exe/videosnap -w 1 -p 'High' ~/Movies/$(date '+%Y-%m-%d %H_%M_%S').mp4 &
        ;;
    "captureVideoKill" )
        pid=`pgrep videosnap`
        [[ -z "$pid" ]] || kill -9 "$pid"
        ;;
    "broadcast" )
        ffmpeg -f avfoundation -framerate 30 -video_size 640x480 -i "0:0" -vcodec libx264 -preset ultrafast -acodec libmp3lame -ar 44100 -ac 1 -f flv rtmp://localhost:8035/rtmplive/room &>/dev/null
        ;;
    "broadcastKill" )
        pid=`pgrep ffmpeg`
        [[ -z "$pid" ]] || kill -9 "$pid"
        ;;
    * )
        echo "not such pattern"
        ;;
esac
