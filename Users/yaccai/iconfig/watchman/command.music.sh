#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

MediaPath=/Volumes/Bak/Doc/iTunes/iTunesMedia
[[ -e "$MediaPath" ]] || exit


for it in "$@"; do
    echo "    catch  $it"
    itmd5="$(md5 -q "$it")"
    count=0
    find "$MediaPath" -name "*${it##*\ }" | while read target; do
        [ "$itmd5" = `md5 -q "$target"` ] && ((count+=1))
    done
    [ $count -eq 0 ] || continue
    rsync -a -- "$it" "$MediaPath/Automatically Add to iTunes.localized"
done
