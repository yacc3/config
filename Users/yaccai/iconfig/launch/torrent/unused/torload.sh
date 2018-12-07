#!/bin/zsh
# coding:utf-8

load_to_utorrent_uncheck () {
    i=1
    cat /tmp/newutor.txt | while read it; do
        it="${it/amp;/}"
        [[ -f "$it" ]] || {continue}
        name=`echo "$it" | sed "s/.*\///;s/\.[^.]*\.torrent$//"`
        printf "%3d  %s\n" "$((i++))" "$name"
        torf=`torrentcheck -t "$it" | ggrep -oP "(?<=Torrent name  : ).*$"`
        name="$torf - 添加新的 Torrent"
        open -a uTorrent "$it"
        (/usr/bin/osascript <<EOF
            tell application "System Events"
                tell process "uTorrent"
                    if exists button "确定" of window "$name" then
                        tell pop up button 1 of group "另存为" of window "$name"
                            click
                            tell menu 1
                                click menu item "/Volumes/Store/Torrent"
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
    cp  -rf "$it" "/Volumes/Doc/Torrent/Seeds"
    done
}

load_to_utorrent_uncheck "$@"
