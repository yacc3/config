#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

# curl -s 'http://192.168.1.1/login.cgi?username=useradmin&psd=puv6f' &>/dev/null
# curl -s myip.ipip.net

apps=(
    Vuze
    uTorrent
    qBittorrent
    Transmission
)

for app in "${apps[@]}"; do 
    test -d /Applications/"$app".app || continue
    wp=~/Library/Application\ Support/"$app"/watch
    mkdir -p "$wp"
    find "$wp" -name "*.torrent" -or -name "*.imported" -Btime +3m -print -delete
done

echo "done"
echo