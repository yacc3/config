#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

bakd=/Volumes/Store/Daily/`date +'%Y/%Y-%m-%d'`
mkdir -p "$bakd" || exit

[[  $# -gt 5  ]] && exit
for it in "$@"; do
    echo "    catch  ${it##*/}"
    rsync -tr -- "$it" "$bakd"
done