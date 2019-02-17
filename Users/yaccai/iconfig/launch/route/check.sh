#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

curl -s 'http://192.168.1.1/login.cgi?username=useradmin&psd=puv6f' &>/dev/null
# curl -s myip.ipip.net

chflags hidden ~/Onedrive

echo "done"
echo