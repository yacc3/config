#!/bin/zsh
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
root=/Volumes/Store
bakd=$root/Daily/`date +'%Y/%Y-%m-%d'`
mkdir -p "$bakd" || exit

for it in "$@"; do
    [[ $it =~ "[[0-9]{1,2}].mp4" ]] && continue
    echo "     catch $it"
    type="${it##*.}"
    case "$type" in
        torrent)
            if [[ "$it" =~ "^[0-9a-z]{20,60}\.torrent$" ]]; then # 是t66型种子
                
            else
                pgrep uTorrent &>/dev/null || open -a uTorrent
                mkdir -p ~/Library/Application\ Support/uTorrent/watch
                mv "$it" ~/Library/Application\ Support/uTorrent/watch
            fi
            ;;
        dmg|pkg) 
            rsync -a -- "$it" "$root/MacOS"
            ;;
        exe)
            rsync -a -- "$it" "$root/Windows"
            ;;
        mp3|aac|m4a|wav)
            MediaPath=~/Music/iTunes/iTunes\ Media
            itmd5="$(md5 -q "$it")"
            count=0
            find "$MediaPath" -name "*${it##*\ }" | while read target; do
                [ "$itmd5" = `md5 -q "$target"` ] && ((count+=1))
            done
            [ $count -eq 0 ] || continue
            rsync -a -- "$it" "$MediaPath/Automatically Add to iTunes.localized"
            ;;
        *) 
            rsync -a -- "$it" "$bakd"
            ;;
    esac
done

            # test -d /Applications/Vuze.app && \
            #     mv "$it" ~/Library/Application\ Support/Vuze/watch
            # test -d /Applications/qBittorrent.app && \
            #     mv "$it" ~/Library/Application\ Support/qBittorrent/watch
            # test -d /Applications/Transmission.app && \
            #     mv "$it" ~/Library/Application\ Support/Transmission/watch
            # test -d /Applications/uTorrent.app && \
            #     mv "$it" ~/Library/Application\ Support/uTorrent/watch