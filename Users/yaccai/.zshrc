#!/bin/bash
export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell" # ZSH_THEME="agnoster"
fpath=(/usr/local/share/zsh-completions $fpath)
plugins=(git extract colored-man-pages encode64 osx ) 
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/Library/TeX/texbin"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

alias  rc='code ~/.zshrc       ~/iconfig'
alias src='source ~/.zshrc'
alias etc='code /usr/local/etc /usr/local/var'

alias c='cd /Volumes/Store/Code'
alias a='aria2c -c -x 10 --file-allocation=none'
alias u=' you-get -o ~/Downloads'
alias px='ALL_PROXY=socks5://127.0.0.1:1086'
alias cx='curl -x http://127.0.0.1:1087'

alias et='~/iconfig/shell/edit.sh'
alias sp='~/iconfig/shell/edit.sh searchPoem'
alias tx='~/iconfig/shell/edit.sh newEdit'
alias bs='~/iconfig/shell/edit.sh findBlog'

alias lh='~/iconfig/shell/launchctl.sh'
alias wh='~/iconfig/shell/watchman.sh'

alias sy='~/iconfig/shell/system.sh'
alias js='~/iconfig/shell/system.sh arithmetic'
alias kl='~/iconfig/shell/system.sh killLaunchpad'
alias ap='~/iconfig/shell/system.sh accessPoint'
alias fp='~/iconfig/shell/system.sh findplist'
alias  b='~/iconfig/shell/system.sh bright'
alias  v='~/iconfig/shell/system.sh volume'
alias pi='~/iconfig/shell/system.sh pip_proxy'

alias  me='~/iconfig/shell/media.sh'
alias  yx='~/iconfig/shell/media.sh yixiu'
alias  dl='~/iconfig/shell/media.sh douyin_download'
alias  tm='~/iconfig/shell/media.sh togglemovist'
alias day='~/iconfig/shell/media.sh openDailyMedia'

alias rf='rm -rf '
alias nv='~/iconfig/exe/nvshen.py'
alias tk='~/iconfig/exe/torcheck.py'
alias dc='~/iconfig/exe/douyin.py check'
alias gz='hdiutil attach /Volumes/Store/llvm日志文件-需要clang调试'
alias yd='youtube-dl --proxy "socks5://127.0.0.1:1086"'
alias cl='~/iconfig/exe/caoliu.py'
alias kxl='killall Thunder;launchctl remove com.xunlei.Thunder.ThunderHelper'
alias top='top -n 15 -o cpu -s 2 -stats pid,command,cpu,mem,pstate,time'

# hdiutil create -type SPARSEBUNDLE -fs JHFS+ -size 1t -volname Daily -autostretch Daily