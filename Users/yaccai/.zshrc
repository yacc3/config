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
alias lt='cd /Volumes/Store/Code/leetcode'
alias a='aria2c -c -x 10 --file-allocation=none'
alias u=' you-get -o ~/Downloads'
alias uo='you-get -o ~/OneDrive'
alias px='ALL_PROXY=socks5://127.0.0.1:1086'
alias cx='curl -x http://127.0.0.1:1087'
alias cl='~/iconfig/exe/caoliu.py'

alias et='~/iconfig/shell/edit.sh'
alias sp='~/iconfig/shell/edit.sh searchPoem'
alias gp='~/iconfig/shell/edit.sh gitpush'
alias tx='~/iconfig/shell/edit.sh newEdit'
alias bb='~/iconfig/shell/edit.sh buildBlog'
alias bs='~/iconfig/shell/edit.sh serveBlog'
alias bp='~/iconfig/shell/edit.sh pushBlog'
alias bf='~/iconfig/shell/edit.sh findBlog'
alias be='code /Volumes/Store/Code/yacc3.github.src'


alias lh='~/iconfig/shell/launchctl.sh'
alias wh='~/iconfig/shell/watchman.sh'

alias sy='~/iconfig/shell/system.sh'
alias js='~/iconfig/shell/system.sh arithmetic'
alias kl='~/iconfig/shell/system.sh killLaunchpad'
alias ap='~/iconfig/shell/system.sh accessPoint'
alias fd='~/iconfig/shell/system.sh gnufind'
alias  b='~/iconfig/shell/system.sh bright'
alias  v='~/iconfig/shell/system.sh volume'

alias me='~/iconfig/shell/media.sh'
alias nv='~/iconfig/exe/nvshen.py'
alias yx='~/iconfig/shell/media.sh yixiu'
alias sc='~/iconfig/shell/media.sh captureScreen'

alias day='open /Volumes/Store/Daily/`date +"%Y/%Y-%m-%d"`'
alias top='top -n 15 -o cpu -s 2 -stats pid,command,cpu,mem,pstate,time'
