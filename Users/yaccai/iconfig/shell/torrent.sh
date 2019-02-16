#!/bin/zsh
# coding:utf-8


if [[ $# -eq 0 ]]; then
    exit
fi

case "$1" in
    "help" )
        echo "subcommand:"
        cat "$0" | awk  '/"[a-zA-Z\_\-\+0-9]+" \)/{print $0}' | sed 's/"//g; s/)//g'
        ;;
    "run" )
        ~/iconfig/launch/torrent/torrent.py
        ;;
    "log" )
        tail -n 55 -f ~/iconfig/launch/torrent/torrent.log
        ;;
    "list" )
        ~/iconfig/launch/torrent/torclean.py list
        ;;
    "load" )
        ~/iconfig/launch/torrent/torload.py
        ;;
    "move" )
        ~/iconfig/launch/torrent/tormove.py
        ;;
    "clean" )
        ~/iconfig/launch/torrent/torclean.py remove
        find    ~/Library/Application\ Support/Vuze/watch \
        ~/Library/Application\ Support/Transmission/watch \
        ~/Library/Application\ Support/Vuze/watch \
        ~/Downloads \
        /tmp \
        -name "*.torrent" -print -delete
        ;;
    "settg" )
        gsed "s/^gusl.*$/gusl=$2/" -i ~/iconfig/launch/torrent/torrent.py
        ;;
    "iftopt" )
        sudo iftop -i en5 -B -b -n -f "src port 61137 or src port 61138 or src port 61139"
        ;;
    "speed" )
        ~/iconfig/launch/torrent/upload.py speed
        ;;
    "setsp" )
        ~/iconfig/launch/torrent/setsp.py "${@:2}"
        ;;
    "size" )
        ~/iconfig/launch/torrent/upload.py size "${@:2}"
        ;;
    "seekdata" )
        ~/iconfig/launch/torrent/torseek.py "${@:2}"
        ;;
    "exchange" )
        curl -H "$cook" -d 'option=3&art=traffic' 'https://pt.sjtu.edu.cn/mybonus.php?action=exchange' &>/dev/null
        ;;
    "cleanWatch" )  # clean it
        find    ~/Library/Application\ Support/uTorrent/watch \
                ~/Library/Application\ Support/qBittorrent/watch \
                ~/Library/Application\ Support/Transmission/watch \
                ~/Library/Application\ Support/Vuze/watch \
                ~/Downloads \
                /tmp \
                -name "*.torrent" -print -delete
        ;;
    * )
        echo "no such pattern"
        ;;
esac
