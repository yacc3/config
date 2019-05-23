#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
[[  $# -gt 5  ]] && exit

# bakd=/Volumes/Store/Daily/`date +'%Y/%Y-%m-%d'`
# mkdir -p "$bakd" || exit
bakd=/Volumes/Store/com.tencent.xinWeChat
mkdir -p "$bakd" || exit

for it in "$@"; do
    echo "    catch  ${it##*/}" # ##*/
    echo "      @    $bakd/${it%/*}"
    rsync -trR -- "$it" "$bakd"
done