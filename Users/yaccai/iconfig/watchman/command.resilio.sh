#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

bakd=/Volumes/Store/Daily/`date +'%Y/%Y-%m-%d'`
mkdir -p "$bakd" || exit

sfix=`date +'%Y%m%d_%H%M%S_'`
for it in "$@"; do
    echo "    catch  ${it##*/}" # ##*/
    if [[ "${it##*.}" == "torrent" ]]; then
        rsync -a --remove-source-files -- "$it" ~/Downloads
    else
        rsync -a --remove-source-files -- "$it" "$bakd/${sfix}_${it##*/}"
    fi    
done

find ~/Resilio\ Sync/iPhone\ Camera\ backup -type f -mindepth 1 -exec touch {} +