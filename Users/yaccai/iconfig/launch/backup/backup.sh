#!/bin/zsh
# coding:utf-8
/bin/date +'%Y-%m-%d %T ...'
PATH="/usr/local/bin:$PATH"

bakd="/Volumes/Doc"
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

echo "备份 iTunes"
rsync -a ~/Music/iTunes "$bakd"

echo "备份 Sublime Text 3"
rsync -af '- Cache' ~/Library/Application\ Support/Sublime\ Text\ 3  "$bakd"

echo "备份 微信"
suffix="__$(date +%Y%m%d%H%M%S).bak"
rsync -af '- Backup' ~/Library/Containers/com.tencent.xinWeChat "$bakd" # 排除Backup
rsync -af '+ Backup' ~/Library/Containers/com.tencent.xinWeChat "$bakd" -b --suffix="$suffix"
# gfind . -regextype posix-egrep -regex '.*__[0-9]{14}.bak$'

echo "备份 Code"
rsync -a ~/Code "$bakd"

echo "备份 Fonts"
rsync -a ~/Library/Fonts "$bakd"

echo "备份 磁盘"
if [[ -d /Volumes/Googol ]]; then
    rsync -af '- /Doc/.*' /Volumes/Doc /Volumes/Googol
    # find /Volumes/Doc/Homebrew -size +20M -delete
    # find /Volumes/Doc/Homebrew -type f | sort -r | while read it; do
    #     [ "$pname" = "${it/--*/}" ] && rm "$it"
    #     pname="${it/--*/}"
    # done
    # rsync -a --remove-source-files /Volumes/Doc/Daily /Volumes/Googol/Backup
    # rsync -a --remove-source-files /Volumes/Doc/Model /Volumes/Googol/Backup
    # find /Volumes/Doc/Daily -type d -mindepth 1 -delete
    # find /Volumes/Doc/Model -type d -mindepth 1 -delete
fi

echo "调用 TimeMachine"
tmexclpath=(
    "/Users/yaccai/Library/Application Support/com.colliderli.iina"
    "/Users/yaccai/Library/Application Support/iMazing"
    "/Users/yaccai/Library/Application Support/iMazing Mini"
    "/Users/yaccai/Library/Application Support/qBittorrent"
    "/Users/yaccai/Library/Application Support/Transmission"
    "/Users/yaccai/Library/Application Support/uTorrent"
    "/Users/yaccai/Library/Application Support/Vuze/watch"
    "/Users/yaccai/Library/Application Support/Code"
    "/Users/yaccai/Library/Containers/com.tencent.xinWeChat"
    "/Users/yaccai/Library/Metadata"
    "/Users/yaccai/Code"
    "/Users/yaccai/Downloads"
    )

# [ `date +%H` -lt 6 ] && {
#     for excl in "${tmexclpath[@]}"; do
#         test -d "$excl" || continue
#         tmutil isexcluded   "$excl" &>/dev/null && continue
#         tmutil addexclusion "$excl"
#     done
#     tmutil startbackup
# }

echo "done"
echo


# rsync -avn -f '+ shell/***' -f '- */*' ~/Code  . # 只传输shell