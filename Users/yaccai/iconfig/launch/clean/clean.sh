#!/bin/zsh
# coding:utf-8

/bin/date +'%Y-%m-%d %T ...' # clean befor backup

find ~/Library/Caches    -type f       -exec rm -rf {} +
find ~/Library/Caches    -type l       -exec rm -rf {} +
find /usr/local/Caskroom -name "*.pkg" -exec rm -rf {} +
find /usr/local/Caskroom -name "*.app" -exec rm -rf {} +
find /usr/local/Caskroom -name "*.app" -exec rm -rf {} +

brew cleanup &>/dev/null