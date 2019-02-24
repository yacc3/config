#!/bin/zsh
# coding:utf-8

/bin/date +'%Y-%m-%d %T ...' # clean befor backup
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

echo "clean homebrew"
brew cask upgrade
brew upgrade
brew cleanup

echo "clean caches"
find ~/Library/Caches                                     -type f -exec rm -rf {} +
find ~/Library/Caches                                     -type l -exec rm -rf {} +
find ~/Library/Containers           -iname "Caches"  -d 4 -type d -exec rm -rf {} +
find ~/Library/Application\ Support -iname "*Cache*" -d 2 -type d -exec rm -rf {} +

echo "clean apps"
find /usr/local/Caskroom -name "*.pkg" -exec rm -rf {} +
find /usr/local/Caskroom -name "*.app" -exec rm -rf {} +

XL=/Applications/Thunder.app/Contents/Bundles/XLPlayer.app
test -d "$XL" && {
    echo "clean Thunder"
    rm -rf "$XL"
}

GC=/Applications/Google\ Chrome.app/Contents/Versions
[[ -d "$GC" && `ls "$GC" | wc -l` -gt 1 ]] && {
    echo "clean Chrome version"
    rm -rf "$GC/$(ls "$GC" | head -n1)"
}

GU=~/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall
test -e "$GU" && {
    echo "clean GoogleUpdate"
    "$GU" --nuke
}

IC=~/Library/Application\ Support/com.colliderli.iina/thumb_cache
test -d "$IC" && {
    echo "clean iina cache"
    rm -rf "$IC"
}

for app in Vuze uTorrent qBittorrent Transmission; do 
    test -d /Applications/"$app".app || continue
    wp=~/Library/Application\ Support/"$app"/watch
    mkdir -p "$wp"
    find "$wp" -name "*.torrent" -or -name "*.imported" -Btime +3m -print -delete
done

echo "clean disabled torrents at uTorrent"
stmp=`ps -eo lstart,command | grep "[u]Torrent" | awk -F '/' '{print $1}'`
secd=`date -j -f "%a %b %d %T %Y" "$stmp" "+%s" 2>/dev/null` # ut启动时间
find ~/Library/Application\ Support/uTorrent -name "*.torrent" | while read tor; do
    act=`/usr/bin/stat -t '%s' -f "%Sa" "${tor}"`
    [[ $secd -gt $act ]] && rm "${tor}"
done


echo "done"
echo
echo