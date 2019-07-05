#!/bin/bash
# coding:utf-8

if [[ ! -d /volumes/Store ]]; then
    echo "require backup disk!"
    exit
fi 

function recover_iTunes () {
    if [[ ! -L ~/Music/LyricsX ]]; then
        if [[ -d ~/Music/LyricsX ]]; then
            echo "合并  ~/Music/LyricsX  到  /Volumes/Store/iTunes/LyricsX "
            cp -r ~/Music/LyricsX /Volumes/Store/iTunes
            find  ~/Music/LyricsX -delete
            rmdir ~/Music/LyricsX
        fi
        ln -sfF /Volumes/Store/iTunes/LyricsX ~/Music
    fi 

    if [[ ! -L ~/Music/iTunes ]]; then
        if [[ -d ~/Music/iTunes ]]; then
            find  ~/Music/iTunes -delete # 没有 -L不跟进链接
            rmdir ~/Music/iTunes
        fi
        ln -sfF /Volumes/Store/iTunes  ~/Music
    fi
}

function recover_wechat () {
    rsync -avh /Volumes/Store/com.tencent.xinWeChat  ~/Library/Containers
}

function recover_others () {
    touch ~/Downloads/.localized
}


function backup () {
    echo "backup data to /Volumes/Store, before reinstall OS"
    ~/iconfig/launch/backup/backup.sh
}