#!/bin/zsh
# coding:utf-8
/bin/date +'%Y-%m-%d %T ...'
PATH="/usr/local/bin:$PATH"

bakd="/Volumes/Bak/Backup"
test -d "$bakd" || exit -1

sfix=`date +'_%Y-%m-%d-%H-%M-%S.bak'`
nows=`date +%s`
nowd=`date +%Y-%m-%d`

echo "备份 app列表"
pip3 list      > "$bakd/pip3"
brew list      > "$bakd/brew"
brew cask list > "$bakd/brewc"

mkdir -p "$bakd/$nowd" && {
    echo "备份 配置文件"
    cat ~/iconfig/launch/backup/config.include | while read it; do
        [[ -e "$it" ]] || continue
        rsync -aR  --delete         "$it" "$bakd/$nowd/conf"
        rsync -abR --suffix="$sfix" "$it" "$bakd/conf"
    done
}
oldd=`date -v-8d +'%Y-%m-%d'`
test -d "$bakd/$oldd" && rm -rf "$bakd/$oldd"

echo "备份 iTunes"
rsync -a ~/Music/iTunes "$bakd/iTunesMedia"

echo "备份 Sublime Text 3"
rsync -a ~/Library/Application\ Support/Sublime\ Text\ 3  "$bakd"

echo "备份 微信"
rsync -a ~/Library/Containers/com.tencent.xinWeChat  "$bakd"

echo "备份 Code"
rsync -a ~/Code "$bakd"

echo "备份 Homebrew"
find ~/Library/Caches/Homebrew -type l | while read it; do 
    rsync -aL "$it" "${it/*Caches/$bakd}"
done

echo "备份 Fonts"
rsync -a ~/Library/Fonts "$bakd"

echo "备份 磁盘"
if [[ -d /Volumes/Store/Picture ]]; then
    rsync -a /Volumes/Bak/Backup /Volumes/Store
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

[ `date +%H` -lt 5 ] && {
    for excl in "${tmexclpath[@]}"; do
        test -d "$excl" || continue
        tmutil isexcluded "$excl" &>/dev/null || continue
        tmutil addexclusion "$excl"
    done
    tmutil startbackup
}

echo "done"
echo
