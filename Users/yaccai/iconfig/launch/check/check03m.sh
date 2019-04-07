#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

# curl -s 'http://192.168.1.1/login.cgi?username=useradmin&psd=puv6f' &>/dev/null
# curl -s myip.ipip.net
find /Volumes/Store/Downloads/t66ydone -type f | while read it; do
    [[ "${it##*.}" == 'rar' ]] && rm "$it"
    [[ "${it##*.}" == 'zip' ]] && rm "$it"

    sizem=`du -sm "$it" | awk '{print $1}'`
    if [ $sizem -lt 100 ]; then
        rm "$it"
    else
        mv "$it" /Volumes/Store/Torrent/10V
    fi
done
# find /Volumes/Store/Downloads/t66ydone -type d -delete

echo "done"
echo
