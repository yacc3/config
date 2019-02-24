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
cat ~/iconfig/launch/backup/config.include | while read it; do
    [[ -e "$it" ]] && rsync -aR  "$it" "$bakd/Config"
done 
git -C "$bakd/Config" add -A &>/dev/null
git -C "$bakd/Config" commit -m "$(date +'%Y-%m-%d %T')" &>/dev/null

echo "备份 Sublime Text 3"
rsync -af '- Cache' ~/Library/Application\ Support/Sublime\ Text\ 3  "$bakd"

echo "备份 微信"
suffix="__$(date +%Y%m%d%H%M%S).bak"
rsync -af '- Backup' ~/Library/Containers/com.tencent.xinWeChat "$bakd" # 排除Backup
rsync -af '+ Backup' ~/Library/Containers/com.tencent.xinWeChat "$bakd" -b --suffix="$suffix"

echo "备份 Code"
rsync -a ~/Code "$bakd"

echo "备份 Fonts"
rsync -a ~/Library/Fonts "$bakd"

[[ -d /Volumes/Googol/Doc ]] && {
    echo "备份 磁盘"
    find "$bakd" -name '._*' -or -name '.DS_Store'  -delete
    for item in Code                   \
                Config                 \
                Daily                  \
                Doc                    \
                Fonts                  \
                Homebrew               \
                Linux                  \
                MacOS                  \
                Model                  \
                Picture                \
                Sublime\ Text\ 3       \
                Windows                \
                com.tencent.xinWeChat  \
                iTunesMedia            \
                vuze                   \
        rsync -a "$bakd/$item" /Volumes/Googol/Doc
    done
}

[[ `date +%H` -lt 6 ]] && {
    echo "调用 TimeMachine"
    for excl in "/Users/yaccai/Library/Application Support/com.colliderli.iina"  \
                "/Users/yaccai/Library/Application Support/iMazing"              \
                "/Users/yaccai/Library/Application Support/iMazing Mini"         \
                "/Users/yaccai/Library/Application Support/qBittorrent"          \
                "/Users/yaccai/Library/Application Support/Transmission"         \
                "/Users/yaccai/Library/Application Support/uTorrent"             \
                "/Users/yaccai/Library/Application Support/Vuze/watch"           \
                "/Users/yaccai/Library/Application Support/Code"                 \
                "/Users/yaccai/Library/Containers/com.tencent.xinWeChat"         \
                "/Users/yaccai/Library/Metadata"                                 \
                "/Users/yaccai/Code"                                             \
                "/Users/yaccai/Downloads"                                        \
                "/Users/yaccai/Music"; do
        test -d "$excl" || continue
        tmutil isexcluded   "$excl" &>/dev/null && continue
        tmutil addexclusion "$excl"
    done
    tmutil startbackup
}

echo "done"
echo