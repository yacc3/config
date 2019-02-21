#!/bin/bash
export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell" # ZSH_THEME="agnoster"
fpath=(/usr/local/share/zsh-completions $fpath)
plugins=(git extract colored-man-pages encode64 osx zsh-syntax-highlighting) 
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/Library/TeX/texbin"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

alias  rc='open -a /Applications/Visual\ Studio\ Code.app ~/.zshrc  ~/iconfig'
alias src='source ~/.zshrc'
alias etc='open -a /Applications/Visual\ Studio\ Code.app /usr/local/etc /usr/local/var'

alias a='aria2c -c -x 10 --file-allocation=none'
alias u='you-get -o ~/Downloads'
alias px='ALL_PROXY=socks5://127.0.0.1:1086'
alias cx='curl  -x  socks5://127.0.0.1:1086'

alias et='~/iconfig/shell/edit.sh'
alias tx='~/iconfig/shell/edit.sh newEdit'
alias bs='~/iconfig/shell/edit.sh searchBlog'
alias sp='~/iconfig/shell/edit.sh searchPoem'

alias lh='~/iconfig/shell/launchctl.sh'
alias wh='~/iconfig/shell/watchman.sh'

alias sy='~/iconfig/shell/system.sh'
alias js='~/iconfig/shell/system.sh arithmetic'
alias kl='~/iconfig/shell/system.sh killLaunchpad'
alias ap='~/iconfig/shell/system.sh accessPoint'
alias  b='~/iconfig/shell/system.sh bright'
alias  v='~/iconfig/shell/system.sh volume'

alias me='~/iconfig/shell/media.sh'
alias yx='~/iconfig/shell/media.sh yixiu'
alias nv='~/iconfig/shell/media.sh nvshens'

alias day='open /Volumes/Store/Daily/`date +"%Y/%Y-%m-%d"`'
alias top='top -n 15 -o cpu -s 2 -stats pid,command,cpu,mem,pstate,time'
