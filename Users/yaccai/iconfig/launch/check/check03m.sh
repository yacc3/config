#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

/usr/local/bin/python3 ~/iconfig/exe/pt_invite.py
/usr/local/bin/python3 ~/iconfig/exe/douyin.py     && echo "done douyin"

echo "done"
echo
