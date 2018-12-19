#!/bin/zsh
# coding:utf-8


if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  "/\"[a-zA-Z\_\-\+0-9]+\" \)/{print $1}" | sed "s/\"//g; s/)//g"
    exit
fi

case "$1" in
    "list" ) 
        launchctl list | gsed "/yaccai/Ip;1!d"
        ;;
    "install" )     # <label>.plist
        fname=`basename "$2"`
        launchctl remove    "yaccai.${fname/.plist/}"       &>/dev/null
        launchctl unload -w ~/Library/LaunchAgents/"$fname" &>/dev/null

        cp -rf "$2"         ~/Library/LaunchAgents
        launchctl load   -w ~/Library/LaunchAgents/"$fname"
        launchctl list | gsed "/yaccai/Ip;1!d"
        ;;
    "remove" )      # <label>
        label="$2"
        launchctl remove                           "$label"             &>/dev/null
        launchctl unload -w ~/Library/LaunchAgents/"${label##*.}.plist" &>/dev/null
        rm                  ~/Library/LaunchAgents/"${label##*.}.plist"
        launchctl list | gsed "/yaccai/Ip;1!d"
        ;;
    "start" )       # <label>
        launchctl start "yaccai.$2"
        ;;
    * )
        echo "no such pattern"
        ;;
esac

# ~/Library/LaunchAgents   # for this User
# /Library/LaunchAgents    # for every User
# /Library/LaunchDaemons   # for every User, for backgroud

