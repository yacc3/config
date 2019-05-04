#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

t66yd=/Volumes/Store/Downloads/t66ydone
test -d /Volumes/Store && {
    gfind "${t66yd}" -type f -iname '*.zip' -delete
    gfind "${t66yd}" -type f -iname '*.rar' -delete
    gfind "${t66yd}" -type f -size +80M -exec mv '{}' /Volumes/Store/Torrent/10V \;
    gfind "${t66yd}" -mindepth 1 -depth -delete
}
./douyin.py


echo "done"
echo
