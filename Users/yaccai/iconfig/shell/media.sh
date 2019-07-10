#!/bin/zsh
# coding:utf-8

if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  '/"[a-zA-Z_\-\+0-9]+" \)/{print $0}' | sed 's/"//g; s/)//g'
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
    "captureScreen" )
        name=$(date +%s)
        screencapture -t 'jpg' ~/Library/Caches/$name.jpg
        convert -quality 75%   ~/Library/Caches/$name.jpg ~/OneDrive/图片/$name.jpg
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
    "wav" )                 # $2:<name>[.wav]    切割ape无损音乐为单曲wav
        bchunk -wv "$2".wav "$2".cue prefix__
        ;;
    "douyin_check" )
        ls -1 ~/Desktop | while read it; do
            echo "$it"
            cat  ~/Desktop/"$it"
            echo
        done
        ;;
    "douyin_download" )     # 抖音url -->  http://v.douyin.com/katEpn/
        url=`echo "$2" | ggrep -oP "http://v.douyin.com/[0-9a-zA-Z]{6}/"`
        url=`curl -s "$url" | ggrep -oP '(?<=").*(?=")' | gsed 's/amp;//g'`
        # 以上获取跳转后，加了一堆参数的url，这个是点击后能播放的页面
        html=`curl -s "$url" -H 'authority: www.iesdouyin.com' -H 'cache-control: max-age=0' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8,pt;q=0.7' -H 'cookie: _ga=GA1.2.1989596399.1562658925; _gid=GA1.2.1691794912.1562658925; tt_webid=6711599768907761164; _ba=BA0.2-20190709-5199e-cy7wZzFZzaalz7yuZIcq' --compressed`
        # 播放页面的html源文件
        vurl=`echo "$html" | ggrep -oP "(?<=playAddr: \").*(?=\")"`
        name=`echo "$html" | ggrep -oP "(?<=class=\"desc\">)[^<>]*"`
        svid=`echo "$html" | ggrep -oP "(?<=s_vid\\=)[0-9a-z]*"`
        [ -z "$name" ] && name=$svid
        user=`echo "$html" | ggrep -oP "(?<=name nowrap\">@)[^<]*"`
        mkdir -p "/Volumes/Store/douyin/$user/"
        wget --show-progress -qc -O "/Volumes/Store/douyin/$user/$name.mp4" "${vurl}"
        ;;
    "togglemovist" )
        /usr/bin/osascript <<EOF
        tell application "Movist Pro"
            if it is running then
                activate
                tell application "System Events" to keystroke " "
            end if
        end tell
EOF
        ;;
    * )
        echo "not such pattern"
        ;;
esac
