#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

test -d /Volumes/Store && {
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -iname '*.zip' -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -iname '*.rar' -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -size +100M -print0 | /usr/local/bin/gxargs -0 -I {} mv {} /Volumes/Store/Torrent/10V
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -delete
}

/usr/local/bin/fping -t 50 www.douyin.com &>/dev/null && {
    stmp=$(date +'%Y-%m-%d_%H-%M-%S')
    iden=(75382141971 9330557830 101019751610)
    name=(ll          wd         hnn)
    for i in $(seq 1 $#iden); do
        ./douyin.py $iden[i] > $name[i].tmp
        if [[ -f $name[i].log ]]; then
            diff $name[i].tmp $name[i].log &>/dev/null || { # 如果状态有变化，
                say "check $name[i]"
                mv $name[i].log $name[i].$stmp.log
                touch ~/Desktop/$name[i].${stmp:11}
            }
        fi
        mv $name[i].tmp $name[i].log
    done
}


echo "done"
echo
