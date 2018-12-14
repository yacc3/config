#!/bin/zsh
# coding:utf-8

if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  "/\"[a-zA-Z\_\-\+]+\" \)/{print $1}" | sed "s/\"//g; s/)//g"
    exit
fi

case "$1" in
    "killLaunchpad" )
        defaults write com.apple.dock   ResetLaunchPad    -bool true
        killall Dock
        ;;
    "setLaunchpad" )
        columns="7"
        rows="7"
        [ $2 -ge 5 ] && rows=$2
        [ $3 -ge 5 ] && columns=$3
        defaults write com.apple.dock springboard-rows    -int "$rows"    # 设置行数 7
        defaults write com.apple.dock springboard-columns -int "$columns" # 设置列数 9
        defaults write com.apple.dock ResetLaunchPad -bool TRUE  # 重启
        killall Dock
        ;;
    "killDNS" )
        sudo killall -HUP mDNSResponder
        ;;
    "arithmetic" )           # <四则表达式>      : 简单四则混合运算
        echo "$((${@:2}))"
        ;;
    "ShowAllFiles" )         # <true/false>      : 是否显示隐藏文件
        defaults write com.apple.finder AppleShowAllFiles -bool "$2"
        ;;
    "bright0" )               # <数字>            : 0 ~ 1 小数
        osascript <<EOF
        tell application "System Preferences"
            activate
            set current pane to pane "显示器"
            tell application "System Events"
                set value of value indicator 1 of slider 1 of group 1 of tab group 1 of window "内建视网膜显示器" of process "System Preferences" to 0
            end tell
        end tell
EOF
        # osascript -e "tell application \"System Events\" to key code $2"
        ;;
    "volume" )               # <-/+数字>         : 0 ~ 100
        osascript -e "set volume output volume + $2"
        ;;
    "mute" )                 # 静音或关闭静音
        osascript -e "set volume output muted (not output muted of (get volume settings))"
        ;;
    "mountEFI" )
        sudo mkdir -p /Volumes/EFI
        sudo mount -t msdos /dev/disk0s1 /Volumes/EFI
        ;;
    "umountEFI" )
        sudo umount /Volumes/EFI
        ;;
    "createDMG" )            # <folder>    <dmg_name>
        hdiutil create -srcfolder "$2" "$3"
        ;;
    "filetime" )
        find "$2" -d 1 ! -name ".DS_Store" | while read it; do
            stat -t "%Y-%m-%d %H:%M:%S" -f "%S${1}  %N" "$it" | sed "s#$2/##"
        done
        ;;
    "accessPoint" )
        /usr/bin/osascript <<EOF
            tell application "System Preferences"
            activate
            set current pane to pane "共享"
            delay 1
            tell application "System Events"
                click checkbox 1 of row 7 of table 1 of scroll area 1 of group 1 of window 1 of process "System Preferences"
                delay 0.5
                do shell script "networksetup -setairportpower en3 off"
                click checkbox 1 of row 7 of table 1 of scroll area 1 of group 1 of window 1 of process "System Preferences"
                # click button "打开 Wi-Fi" of window 1 of process "System Preferences"
                  click button "打开 Wi-Fi" of sheet 1 of window "共享" of process "System Preferences"
                delay 0.5
                click button "启动" of sheet 1 of window 1 of process "System Preferences"
            end tell
        end tell
EOF
        ;;
    *)
        echo "no such pattern"
        ;;  
esac
