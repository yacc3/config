#!/bin/zsh
# coding:utf-8

if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  '/"[a-zA-Z\_\-\+0-9]+" \)/{print $0}' | sed 's/"//g; s/)//g'
    exit
fi

case "$1" in
    "flush" )
        aria2c -c -x 10 https://mirrors.aliyun.com/ubuntu-releases/xenial/ubuntu-16.04.5-server-i386.iso
        ;;
    "yixiu" )               # 从nvshens.com 下载
        Model="/Volumes/Store/Model/Others/"
        html="$(curl -s $2)"
        [ -e "$Model" ] || Model=.
        html="$(curl -s ${2/m.tu11/www.tu11} | iconv -f gbk)"
        name="$(echo $html | ggrep -oP '(?<=row wzbt text-center\">)[^<>]*(?=<)')"
        url=`echo "$html"  | ggrep -oP "(?<=<img src=\")[^<>]*.jpg" | head -n1`
        for ((i = 0, e = -1; i<= 300 && e < 3; ++i)); do
            wget -T5 --show-progress -qc -P "$Model/$name" --header="Referer: http://www.tu11.com/qingchunmeinvxiezhen" ${url%/*}/$i.jpg && e=-1
            ((e += 1))
        done
        printf "Done  ==>  $Model/$name/\n"
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
    "fp" )                    # find picture 6S:4032x3024
        find . -name '*.jpg' | while read it; do
            size=`identify $it | awk '{print $3}'` 
            [[ "4032x3024" == "$size" ]] || continue
            echo "$it"
            if [[ "$2" == "move" && -d "$3" ]]; then
                mv "$it" "$3"
            fi
        done
        ;;
    * )
        echo "not such pattern"
        ;;
esac


