#!/bin/zsh
# coding:utf-8

/bin/date +'%Y-%m-%d %T ...' # clean befor backup
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

echo "clean homebrew"
# brew cask upgrade
# brew upgrade
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

# echo "clean torrent"
# find ~/Library/Application\ Support/uTorrent -name "*.torrent" -delete
# find ~/Library/Application\ Support/Transmission/watch -name "*.torrent" -delete

gfind /Volumes/Store/com.tencent.xinWeChat -regextype 'egrep' -regex '.*__[0-9]{14}\.bak' | while read it; do
    newfile="${it/__*.bak/}"
    nbsz=`gstat -c '%s' "$newfile"`
    obsz=`gstat -c '%s' "$it"`

    if [[ "$nbsz" -gt "$obsz" ]]; then
        echo "remove ${it##*/}"
        rm "$it"
    fi
done

osascript -e "set volume output volume +3"
~/iconfig/exe/nvshen.py update 1>/dev/null

echo "done"
echo
echo
