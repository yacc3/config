#!/bin/zsh
# coding:utf-8

/bin/date +'%Y-%m-%d %T ...' # clean befor backup

[ `sudo id -u` -eq 0 ] || exit -1