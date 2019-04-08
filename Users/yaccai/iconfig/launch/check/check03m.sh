#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

test -d /Volumes/Store && {
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f \
        \( -iname '*.zip' -or -iname '*.rar' -or -size -120M \) -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -print0 \
        | /usr/local/bin/gxargs -0 -I {} mv {} /Volumes/Store/Torrent/10V
    /usr/local/bin/gfind /Volumes/Store -maxdepth 1 -type f -size +120M -print0 \
        | /usr/local/bin/gxargs -0 -I {} mv {} /Volumes/Store/Torrent/10V
    
    # /usr/local/bin/gfind /Volumes/Store/Torrent/10V/t66y_html -ctime +4 -delete # ctime 大于4天   
}
 
echo "done"
echo
