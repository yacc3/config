#!/bin/zsh
# coding:utf-8

if [[ ! -f "$1" ]]; then
    echo "not a file"
    exit
fi

size=`du -sm "$1" | cut -f 1`
dura=`ffmpeg -i "$1" 2>&1 | ggrep -oP "(?<=Duration: )[^,]*"`
hour=`echo "$dura" | cut -d ':' -f 1`
mint=`echo "$dura" | cut -d ':' -f 2`
secd=`echo "$dura" | cut -d ':' -f 3`
cont=$(((hour * 3600 + mint * 60 + secd) / 300 + 1))

name="${1##*/}"
splitd=~/Downloads/"${name%.*/}"
mkdir -p "$splitd"
echo "$name"
for i in $(seq 0 $cont); do # 
    hour=$((i / 12))
    mint=$((i % 12 * 5))
    printf "%02d -->  ffmpeg -i input.mp4 -ss %02d:%02d:00 -t 300 -c copy -y %d.mp4\n" "$i" "$hour" "$mint" "$i"
    ffmpeg -i "$1" -ss "$hour":"$mint":00 -t 300 -c copy -y "$splitd/$i.mp4" &>/dev/null
done

