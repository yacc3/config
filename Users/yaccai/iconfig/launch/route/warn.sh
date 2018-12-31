#!/bin/zsh
# coding:utf-8

/bin/date +'warn @ %Y-%m-%d %T ...'

sleep 0.2
H=`date +%H`
[[ $H -le 23 && $H -gt 11 ]] && {
    afplay warn.m4a
}


echo "done"
echo