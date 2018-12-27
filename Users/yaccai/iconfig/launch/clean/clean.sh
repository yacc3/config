#!/bin/zsh
# coding:utf-8

/bin/date +'%Y-%m-%d %T ...' # clean befor backup
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

echo "clean homebrew"
brew cask upgrade
brew upgrade
brew cleanup
find /Volumes/Bak/Backup/Homebrew -type f | sort -r | while read it; do
    [ "$pname" = "${it/--*/}" ] && rm "$it"
    pname="${it/--*/}"
done

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
test -d "$GC" && {
    old=`ls "$GC" | sort | head -n1`
    new=`ls "$GC" | sort | tail -n1`
    [[ "$new" == "$old" ]] || {
        echo "clean Chrome version $old"
        rm -rf "$GC/$old"
    }
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


echo "done"
echo
echo