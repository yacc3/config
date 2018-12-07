#!/bin/zsh

recur=false
slink=false
sfolder=""
cfolder=""
while getopts "RLS:C:" arg #选项后面的冒号表示该选项需要参数 参数存在$OPTARG中
do
    case $arg in
        R) recur=true;;
        L) slink=true;;
        S) sfolder=$OPTARG;;
        C) cfolder=$OPTARG;;
        ?) exit 101;;
    esac
done

if [[ "$#" == 0 ]]; then
    echo "-S <源文件夹>"
    echo "-C <比较文件夹>"
    echo "-R 按层次遍历目录"
    return 0;
fi

trav () {
    gstat --format=%A:%n "$2"/* | sort -u | cut -d ":" -f2 | while read f2; do
        f1="$1/$(basename $f2)"
        [[ -L "$f1" || -L "$f2"  ]] && continue

        st="\033[31m××\033[0m"        # 目标在source中不存在
        if [[ -f "$f1" ]]; then
            st="\033[31m× \033[0m"    # 文件存在但不相等
            [ "$(md5 -q $f1)" = "$(md5 -q $f2)" ] && st="==" # 文件存在相同
        elif [[ -d "$f1" ]]; then
            st="~ "                   # 文件夹存在单大小不等
            [ "$(du -s $f1|cut -f1)" -eq "$(du -s $f2|cut -f1)" ] && st="= "
        fi
        printf "$3$st %4s $(basename $f2)\n"  "$(du -sh "$f2"|cut -f1)"

        [ "${st:0:2}" = "==" ] && $slink && sudo ln -sf  "$f1" "$f2"
        [ -d "$f1"           ] && $recur && trav "$f1"   "$f2" "$3        "
    done
}
trav "$sfolder" "$cfolder" ""


return 0
