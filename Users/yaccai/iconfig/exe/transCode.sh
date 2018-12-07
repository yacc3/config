#!/bin/zsh

# trans text to utf-8 code


code=(
    UTF-8
    GBK
    GB18030
    UTF-16
    WINDOWS-1252
    ISO-8859
    )

replace=false
verbose=false


hpinfo () {
    printf "trans code to utf-8 \n"
    printf "tc.sh [option] file \n"
    printf "       -d  replace  \n"
    printf "       -v  verbose  \n"
    printf "       -h  helpinfo \n"
}


if [[ $# == 0 ]] 
then
    hpinfo 
    exit 0
fi


while getopts "dhv" arg #选项后面的冒号表示该选项需要参数 参数存在$OPTARG中
do
    case $arg in
        d) replace=true;;
        h) hpinfo;;
        v) verbose=true;;
    esac
done


for file in "$@"
do
    [[ ! -f "$file" ]] && continue
    $verbose && printf "convert %s\n" "$file"

    i=0
    for c in "${code[@]}"; do
        ((i += 1))
        if iconv -f "$c" -t UTF-8 "$file" 1>"$file.UTF.txt" 2>/dev/null
        then
            $verbose && printf "    try %-15s -- > \033[34mok\033[0m\n" "$c"
            break
        else
            $verbose && printf "    try %-15s ××   wr\n" "$c"
        fi
    done

    if [[ $i == ${#code[@]} ]]
    then
        $verbose && printf "    \033[31mreplace fail !\033[0m\n"
        rm $file.UTF.txt
        return -1
    fi

    if  $replace 
    then
        $verbose && printf "    \033[32mreplace success !\033[0m\n"
        mv $file.UTF.txt "$file"
    fi
done
