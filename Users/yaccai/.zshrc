#!/bin/bash
export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
fpath=(/usr/local/share/zsh-completions $fpath)
plugins=(git extract colored-man-pages encode64 osx zsh-syntax-highlighting) 

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
export PATH="$PATH:/Library/TeX/texbin"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
alias src='source ~/.zshrc'

alias a='aria2c -c -x 10 --file-allocation=none'
alias u='you-get -o ~/Downloads'
alias tk='/usr/local/bin/torrentcheck -t'
alias dh='du -sh'
alias rf='rm -rf'
alias st='/usr/local/bin/subl'
alias pt='lsof -n -i4TCP:'
alias pg='ps aux | grep'
alias px='ALL_PROXY=socks5://127.0.0.1:1086'
alias cx='curl  -x  socks5://127.0.0.1:1086'
alias gpm='git add .;git commit -m "commit @ $(date)";git push origin master'
alias top='top -n 15 -o cpu -s 2 -stats pid,command,cpu,mem,pstate,time'
alias stat='/usr/bin/stat -t "%Y-%m-%d %H:%M:%S"'

alias et='~/iconfig/shell/edit.sh'
alias tx='~/iconfig/shell/edit.sh newEdit'
alias ts='~/iconfig/shell/edit.sh simpleChinese'
alias cs='~/iconfig/shell/edit.sh iTermClean'
alias rn="~/iconfig/shell/edit.sh rename"
alias td="~/iconfig/shell/edit.sh transcode -d"

alias cl='~/iconfig/shell/clean.sh'
alias lh='~/iconfig/shell/launchctl.sh'
alias wh='~/iconfig/shell/watchman.sh'
alias tor='~/iconfig/shell/torrent.sh'

alias sys='~/iconfig/shell/system.sh'
alias  js='~/iconfig/shell/system.sh arithmetic'
alias  b='~/iconfig/shell/system.sh bright0'
alias  v='~/iconfig/shell/system.sh volume'
alias  kl='~/iconfig/shell/system.sh killLaunchpad'
alias  ap='~/iconfig/shell/system.sh accessPoint'

alias me='~/iconfig/shell/media.sh'
alias yx='~/iconfig/shell/media.sh yixiu'
alias nv='~/iconfig/shell/media.sh nvshens'
alias ck='~/iconfig/shell/media.sh captureVideoKill'
alias cv='~/iconfig/shell/media.sh captureVideo'
alias mb='~/iconfig/shell/media.sh broadcast'

# open in finder or subl
alias  rc='code ~/.zshrc  ~/iconfig'
alias etc='code /usr/local/etc /usr/local/var'

alias pday='open /Volumes/Bak/Backup/Picture/`date +"%Y/%Y-%m-%d"`'
alias cutv='~/iconfig/exe/cutv.sh'
alias ip='curl -s myip.ipip.net | ggrep -oE "[0-9.]*"'
alias ipu='printf `curl -s myip.ipip.net | ggrep -oE "[0-9.]*"`:61130 | pbcopy'
alias ipq='printf `curl -s myip.ipip.net | ggrep -oE "[0-9.]*"`:61137 | pbcopy'

alias na='~/iconfig/exe/nvshen.py all'
alias nb='~/iconfig/exe/nvshen.py album'
alias sv='ssh -i ~/.ssh/yaccai root@167.179.82.79'