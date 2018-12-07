#!/bin/zsh
# coding:utf-8


runcount=$(ps aux | grep -E "$(whoami) .* $0" | sed "/grep/d" | wc -l)
if [[ $runcount -gt 2 ]]; then
    echo "shell script running ..."
    exit
fi


movetext=~/iconfig/launch/torrent/tormove.txt
if [[ ! -r "$movetext" ]]; then
    echo "no input completed-torrent list"
    exit
fi


cat "$movetext" | while read it; do
    tid=`echo "$it" | awk -F '###' '{print $1}'`
    tsz=`echo "$it" | awk -F '###' '{print $2}'`
    dst=`echo "$it" | awk -F '###' '{print $3}'`
    src=`echo "$it" | awk -F '###' '{print $4}'`

    [[ -e "$src" && tsz -gt 90000000000 ]] || continue

    if [[ ! -L "$src" ]]; then
        echo "rsync       ${src##*/}"
        tmpd="$(dirname $src)/tmp"
        mkdir -p "$tmpd"
        rsync -avhP --size-only --bwlimit=22000 "$src" "$dst" && { # 
            mv "$src" "$tmpd"
            ln -sfF "$tmpd/$(basename $src)" "$(dirname $src)"
        }
    fi

    if [[  -L "$src" ]]; then
        mv "$src" "${src}_tmplink"
        /usr/local/bin/python3 <<EOF
import transmissionrpc
tc = transmissionrpc.Client('localhost', port=9091)
tc.move_torrent_data("$tid", '/Volumes/Store/Torrent')
EOF
        mv "${src}_tmplink" "$src"
    fi
done



rm $movetext

