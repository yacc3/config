#!/bin/zsh
# coding:utf-8
/bin/date +'%Y-%m-%d %T ...'
PATH="/usr/local/bin:$PATH"

bakd="/Volumes/Store"
test -d "$bakd" || exit -1

echo "备份 app列表"
ls   /Applications                > "$bakd/Config/app"
brew list                         > "$bakd/Config/brew"
brew cask list                    > "$bakd/Config/brewc"
pip3 list | sed "1,2d;s/ .*//"    > "$bakd/Config/pip3"

echo "备份 配置文件"
while read it; do
    [[ -e "$it" ]] && rsync -aR  "$it" "$bakd/Config"
done < ~/iconfig/launch/backup/config.include

fping -qt 200 114.114.114.114 && {
    echo "git  push"
    for repo in /Volumes/Store/Code/yacc3.github.io  \
                /Volumes/Store/Code/yacc3.github.src \
                /Volumes/Store/Config; do
        [[ -d "$repo" ]] || continue
        git -C "$repo" add -A . &>/dev/null
        git -C "$repo" commit -m "$(date +'%Y-%m-%d %T')" &>/dev/null
        git -C "$repo" push origin master &>/dev/null
    done
}

# echo "备份 Sublime Text 3"
# rsync -af '- Cache' ~/Library/Application\ Support/Sublime\ Text\ 3  "$bakd"

echo "备份 微信"
suffix="__$(date +%Y%m%d%H%M%S).bak"
wechat=~/Library/Containers/com.tencent.xinWeChat
rsync -af '- Backup'  "$wechat"  "$bakd" # 排除Backup
rsync -af '+ Backup'  "$wechat"  "$bakd" -b --suffix="$suffix"

test -d ~/Code && {
    echo "备份 Code"
    rsync -a ~/Code "$bakd"   
}

test -d /usr/local/var/mysql && {
    echo "备份 MySQL"
    rsync -a  /usr/local/var/mysql  "$bakd"
    mysqldump -u yaccai -pgo daily passwd > "$bakd/mysql/daily.passwd.sql"
}

echo "备份 Fonts"
rsync -a ~/Library/Fonts "$bakd"

[[ `date +%H` -lt 6 ]] && {
    echo "调用 TimeMachine"
    for excl in "/Users/yaccai/Library/Application Support/com.colliderli.iina"  \
                "/Users/yaccai/Library/Application Support/iMazing"              \
                "/Users/yaccai/Library/Application Support/iMazing Mini"         \
                "/Users/yaccai/Library/Application Support/qBittorrent"          \
                "/Users/yaccai/Library/Application Support/Transmission"         \
                "/Users/yaccai/Library/Application Support/uTorrent"             \
                "/Users/yaccai/Library/Application Support/Vuze"                 \
                "/Users/yaccai/Library/Containers/com.tencent.xinWeChat"         \
                "/Users/yaccai/Library/Metadata"                                 \
                "/Users/yaccai/Code"                                             \
                "/Users/yaccai/Resilio Sync"                                     \
                "/Users/yaccai/Desktop"                                          \
                "/Users/yaccai/Downloads"                                        \
                "/Users/yaccai/Music"; do
        if [[ -d "$excl" && ! -L "$excl" ]]; then
            tmutil isexcluded    "$excl" &>/dev/null && continue
            tmutil addexclusion  "$excl"
        fi
    done
    tmutil startbackup
}

# osascript -e "set volume output volume +3"
~/iconfig/exe/nvshen.py update 1>/dev/null

echo "done"
echo
