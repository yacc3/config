#!/bin/zsh
# coding:utf-8

Model="/Volumes/Bak/Backup/Model"

yixiu () {
    html="$(curl -s $1 | iconv -f gbk)"
    name="$(echo $html | ggrep -oP '(?<=row wzbt text-center\">)[^<>]*(?=<)')"
    url=`echo "$html" | ggrep -oP "(?<=<img src=\")[^<>]*.jpg" | head -n1`
    for i in $(seq 0 100); do
        if wget "${url%/*}/$i.jpg" -P "$Model/Others/$name" -T 30 --show-progress -qcnc; then
            e=0
        else
            ((e += 1))
        fi
        [ $e -eq 3 ] && break
    done
    echo "$Model/Others/$name"
}

getimg() {
    url="${1%/*/*}"    # $1 一个照片的url
    title="${2:-.}"    # $2 下载位置
    printf "\nFetch  =>  $title\n"
    for i in $(seq 0 100); do
        str=`printf "%03d\n" "$i"`
        [ $i -eq 0 ] && str=0
        if wget -P "$title" -q "$url/$str.jpg" -T 30 --show-progress -qcnc; then
            e=0
        else
            ((e += 1))
        fi
        [ $e -eq 3 ] && break
    done
    echo "$title"
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
    "nvshens" )               # 从nvshens.com 下载
        html="$(curl -s $2)"
        [ -e "$root" ] || root=.
        if echo "$2" | ggrep album &>/dev/null; then
            name="$(echo $html | ggrep -oP '(?<=/girl/[0-9]{5}/\" title=\")[^<>]*(?=\")')"
            echo $html | ggrep -oP "<img alt=[^<>]* src=[^<>]* title=[^<>]*>" | while read it; do
                getimg  "$(echo $it | cut -d "'" -f4)" \
                        "$Model/$name/$(echo $it | cut -d "'" -f2)"
            done
        else
            getimg  "$(echo $html | ggrep -oP 'https:[^<>]*/gallery/[0-9/s]*.jpg' | head -n1)" \
                    "$Model/Others/$(echo $html | ggrep -oP '(?<=htilte\">)[^>]*(?=</h1>)')"
        fi
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
