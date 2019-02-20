#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

root=/Volumes/Bak/Doc
[[ -e "$root" ]] || exit

bakd=$root/Daily/`date +'%Y/%Y-%m-%d'`
mkdir -p $bakd || exit

[[ $# -gt 3            ]] && exit
[[ "$@" =~ 'pic_thumb' ]] && osascript<<END
    tell application "wechat"
        activate
        tell application "System Events"
            keystroke "1" using command down
            key code 5 using {command down}
        end tell
    end tell
END

for it in "$@"; do
    rsync -tr -- "$it" "$bakd"
done