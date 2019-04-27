#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

test -d /Volumes/Store && {
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -iname '*.zip' -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -iname '*.rar' -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -size +100M -print0 | /usr/local/bin/gxargs -0 -I {} mv {} /Volumes/Store/Torrent/10V
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -delete
}
/usr/local/bin/fping -t 50 www.douyin.com &>/dev/null && ./douyin.py


echo "done"
echo
