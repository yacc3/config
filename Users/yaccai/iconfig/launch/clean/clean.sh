#!/bin/zsh
# coding:utf-8

/bin/date +'%Y-%m-%d %T ...' # clean befor backup
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

echo "clean caches"
find ~/Library/Caches    -type f       -exec rm -rf {} +
find ~/Library/Caches    -type l       -exec rm -rf {} +

echo "clean apps"
find /usr/local/Caskroom -name "*.pkg" -exec rm -rf {} +
find /usr/local/Caskroom -name "*.app" -exec rm -rf {} +

echo "clean homebrew"
brew cleanup

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
        echo "remove Chrome version $old"
        rm -rf "$GC/$old"
    }
}

echo
echo