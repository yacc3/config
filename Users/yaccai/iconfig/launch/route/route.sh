#!/bin/zsh
# coding:utf-8

/bin/date +'route @ %Y-%m-%d %T ...'

# curl -s 'http://192.168.1.1/login.cgi?username=useradmin&psd=puv6f' &>/dev/null
# curl -s myip.ipip.net

# H=`date +%H`
# M=`date +%M`


mkdir -p ~/Library/Application\ Support/Transmission/watch
mkdir -p ~/Library/Application\ Support/qBittorrent/watch
mkdir -p ~/Library/Application\ Support/uTorrent/watch
mkdir -p ~/Library/Application\ Support/Vuze/watch

find ~/Library/Application\ Support/Transmission/watch \
     ~/Library/Application\ Support/qBittorrent/watch \
     ~/Library/Application\ Support/uTorrent/watch \
     ~/Library/Application\ Support/Vuze/watch \
     -name "*.torrent" -or -name "*.imported" | while read it; do
    tgap=$((`date +%s` - `/usr/bin/stat -t '%s' -f '%a' "$it"`))
    echo "$tgap --> $it"
    if [ $tgap -gt 120 ]; then
        rm "$it"
    fi
done

