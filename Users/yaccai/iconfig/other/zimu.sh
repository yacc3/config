#!/bin/zsh
# coding:utf-8

find ~/Downloads/lz -name "*.ssa" | while read it; do
    name="${it##*/}"
    echo "${name}"
    find "/Volumes/Doc/Downloads/complete/Dragon Ball Z GT Complete Enhanced R2 DVD (720x540 x264 AAC2)" -name "${name/ssa/mp4}" | while read it4; do
        echo "    ${it4%/*}"
        mv "$it" "${it4%/*}"
    done
done
