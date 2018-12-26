#!/bin/bash
# coding:utf-8


init() {
    xcode-select --install
    git clone https://github.com/yaccai/iconfig.git ~/iconfig
}

Homebrew() {
    echo "安装 Homebrew"; read -r
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask

    echo "Homebrew 安装应用"; read -r
    while read -r it; do
        brew fetch "$it" --deps
        touch ~/Downloads/"$it"
    done < ~/iconfig/apps/brews

    while read -r it; do
        brew cask install "$it"
        touch ~/Downloads/"$it"
    done < ~/iconfig/apps/brewcs

    sudo brew  services start supervisor
}

launchctl() {
    echo "安装 launch"
    find ~/iconfig/launch ! -name "s_*.plist" -and -name "*.plist" | while read it; do
        cp -f "$it" ~/Library/LaunchAgents
        launchctl load -w ~/Library/LaunchAgents/"${it##*\/}"
    done
}

watchman() {
    echo "安装 watchman";
    mkdir -p /usr/local/var/run/watchman
    touch /usr/local/var/run/watchman/log
    touch /usr/local/var/run/watchman/sock
    touch /usr/local/var/run/watchman/state
    touch /usr/local/var/run/watchman/pid
    alias mwm='watchman  --logfile=/usr/local/var/run/watchman/log \
                                --sockname=/usr/local/var/run/watchman/sock \
                                --statefile=/usr/local/var/run/watchman/state \
                                --pidfile=/usr/local/var/run/watchman/pid \
                                --log-level=1'
    while read -r it; do
        mwm watch -j < ~/iconfig/watchman/watch."$it".json
        mwm       -j < ~/iconfig/watchman/trigger."$it".json
    done < ~/iconfig/watchman/inlist
}

mas() {
    echo "安装 mac store"; read -r
    /usr/local/bin/mas signin cairuyuan@hotmail.com
    while read app
    do
        /usr/local/bin/mas install "$(echo "$app" | cut -d " " -f 1)"
    done < ~/iconfig/apps/mas    
}


repos() {
    echo "git repo"; read -r
    mkdir -p ~/Code
    git clone https://github.com/yaccai/MenuApp.git           ~/Code/MenuApp
    git clone https://github.com/yaccai/leetcode.git          ~/Code/leetcode
    git clone https://github.com/yaccai/lintcode.git          ~/Code/lintcode
    git clone https://github.com/yaccai/yaccai.github.io.git  ~/Code/yaccai.github.io

    cd ~/Code/yaccai.github.io
    git branch -t origin/source
    git checkout source
}

other() {
    echo "安装 iterm-zsh"; read -r
    /bin/sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/powerline/fonts.git ~/Downloads/fonts
    ~/Downloads/fonts/install.sh

    echo "安装 utorrent"; read -r
    curl -# http://download.ap.bittorrent.com/track/stable/endpoint/utmac/os/osx  -o ~/uTorrent.dmg 

    echo "配置 其他"; read -r
    /usr/local/bin/pip2 install shadowsocks genpac
    /usr/local/bin/gem  install jekyll      jekyll-paginate
    /usr/local/bin/gem  install nokogiri -- --with-xml2-include=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/libxml2 --use-system-libraries


    sudo spctl --master-disable # 关闭app的严格验证
    sudo chsh  -s /bin/zsh; 
         chsh  -s /bin/zsh 

    defaults write com.apple.screencapture location ~/Downloads

    cp   -rf /usr/local/Caskroom/cd-to/*/cdto*/iterm/cd\ to.app  /Applications
    open -a  /usr/local/Caskroom/sogouinput/*/安装搜狗输入法.app

    hdiutil attach /Volumes/Doc/MacOS/"Office 2016 for Mac Cracker.dmg"
    open -a /Volumes/FWMSO2016VL2.0/FWMSO2016VL.app

    # system_profiler SPDisplaysDataType | grep Resolution
    # sudo diskutil cs revert /

    echo "> 其他：airserver 导入Xtrafinder的plist文件, istat-menu的配置文件"
    echo "> 共享：屏幕状态栏图标去掉 文件 远程登录 关闭键盘自动纠正 快捷键 截屏 切换输入法 侧边栏 天气 计算器 股票"
    echo "> 调整Finder 鼠标-自然滚动 触控板-轻点 辅助-三指拖移 音量 电池 屏幕"
}

backup() {
    [[ -d /Volumes/Store ]] || return
    mkdir -p /Volumes/Store/macback
    cp -rf ~/Code /Volumes/Store/macback
    cp -rf ~/iconfig /Volumes/Store/macback
    cp -rf ~/Library/Application\ Support/uTorrent /Volumes/Store/macback
    cp -rf ~/Library/Application\ Support/Transmission /Volumes/Store/macback
    cp -rf ~/Library/Application\ Support/Sublime\ Text\ 3 /Volumes/Store/macback
}

if [[ $# == 0 ]]; then
    echo "<subcmd>"
else 
    echo "exe $1"
    "$1"
fi
