#!/bin/zsh
# coding:utf-8

runcount=$(ps aux | grep -E "$(whoami) .* $0" | sed "/grep/d" | wc -l)
if [[ $runcount -gt 2 ]]; then
    echo "shell script running ..."
    exit
fi

vuzetext=/tmp/vuzetext
maxsize=25000000000 # 25000 000 000
[[ -f "$vuzetext" ]] || exit

cat "$vuzetext" | while read it; do
    src=`echo "$it" | awk -F '###' '{print $1}'`
    tor=`echo "$it" | awk -F '###' '{print $2}'`
    tsz=`echo "$it" | awk -F '###' '{print $3}'`
    [[ -e "$src" ]] || continue

    name=`echo "$it"| awk -F '###' '{printf("%s - 添加新的 Torrent\n", $4)}'`
    tord="/Volumes/Doc/Torrent"
    if [[ "$tsz" -lt "$maxsize" ]]; then # 传输
        tord="/Volumes/Store/Torrent"
        rsync -avhP --size-only --bwlimit=21000 "$src" "$tord"
    else
        mv "$src" "$tord"
    fi
    open -ga uTorrent "$tor"
    (/usr/bin/osascript <<EOF
        tell application "System Events"
            tell process "uTorrent"
                if exists button "确定" of window "$name" then
                    tell pop up button 1 of group "另存为" of window "$name"
                        click
                        tell menu 1
                            click menu item "$tord"
                        end tell
                    end tell -- root location
                    
                    click checkbox "跳过散列检查"  of group 1 of window "$name"
                    click button "确定" of window "$name"-- normal
                end if
                if exists button "是" of window 0 then
                    click button "是" of window 0
                end if
            end tell
        end tell
EOF
) &>/dev/null
    mv "$tor" /Volumes/Doc/Downloads/Seeds
    ~/.shell/torrent.sh cleanWatch
done

rm "/tmp/vuzetext"
