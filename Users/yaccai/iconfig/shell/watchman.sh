#!/bin/zsh
# coding:utf-8


alias mywatchman="/usr/local/bin/watchman \
                    --logfile=/usr/local/var/run/watchman/log \
                    --pidfile=/usr/local/var/run/watchman/pid   \
                    --sockname=/usr/local/var/run/watchman/sock   \
                    --statefile=/usr/local/var/run/watchman/state   \
                    --log-level=1"


if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  "/\"[a-zA-Z\_\-\+0-9]+\" \)/{print $1}" | sed "s/\"//g; s/)//g"
    exit
fi

case "$1" in
    "log" )         # 显示 监测记录
        tail -n 55 -f /usr/local/var/run/watchman/log
        ;;
    "list" )        # 显示 所有path及其trigger
        mywatchman watch-list | jq -r '.roots[]' | while read it; do
            echo "$it"
            mywatchman trigger-list "$it" | jq -r '.triggers[].name' 
            echo
        done
        ;;
    "install" )     # <name.json>
        mywatchman -j < "$2"
        ;;
    "remove" )      # <path> <trigger>
        mywatchman trigger-del "$2" "$3"
        ;;
    * )
        echo "no such pattern"
        ;;
esac
