#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

bakd=/Volumes/Store/Daily/`date +'%Y/%Y-%m-%d'`
mkdir -p "$bakd" || exit


for it in "$@"; do
    echo "    catch  ${it}"
    if [[ "${it##*.}" == "torrent" ]]; then
        rsync -a --remove-source-files -- "$it" ~/Downloads
    else
        rsync -a --remove-source-files -- "$it" "$bakd"
    fi
    
done

find ~/OneDrive -type f -exec touch {} +
find ~/OneDrive -name ".DS_Store" -delete
