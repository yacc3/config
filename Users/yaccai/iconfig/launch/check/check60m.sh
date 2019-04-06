#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

chflags hidden ~/Onedrive

/usr/local/bin/python3 ~/iconfig/exe/caoliu.py
find /Volumes/Store/Downloads/t66ydone -name '*.mp4' -size +50M -print0 | xargs -0 -I {} mv {} /Volumes/Store/Torrent/10V

echo "done"
echo
