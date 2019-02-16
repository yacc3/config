#!/bin/zsh
# coding:utf-8

new() {
    [[ -z "$1" ]] && return
    echo "create new blog: $1"
    date=`/bin/date +%Y-%m-%d`
    file=~/Code/yaccai.blog/_posts/"${date}-$1.md"

    if [[ -f "$file" ]]; then
        echo "already exists: $1"
        return
    fi
    echo "---"               >> "$file"
    echo "layout    : post"  >> "$file"
    echo "title     : $1"    >> "$file"
    echo "date      : $date" >> "$file"
    echo "categort  : []"    >> "$file"
    echo "tags      : []"    >> "$file"
    echo "published : true"  >> "$file"
    echo "---"               >> "$file"
    echo ""                  >> "$file"
    echo ""                  >> "$file"
    echo "<!-- more -->"     >> "$file"
    code                        "$file"
}

renameblog() {
    i=0
    ls ~/Code/yaccai.blog/_posts/*.md | while read it; do
        printf "%3d  ${it##*/}\n" "$((++i))"
        name=`gawk -F ':' '/^title/ {print $2}' "$it" | gsed "s/\ *//g"`
        date=`gawk -F ':' '/^.ate / {print $2}' "$it" | gsed "s/\ *//g"`
        newname="$(dirname $it)/$date-$name.md"
        if [[ "$it" != "$newname" ]]; then
            echo "     ${newname##*/}"
            mv "$it" "$newname"
        fi
    done
}

fcontain () {
    gstat --format=%A:%n "$2"/* | sort -u | cut -d ":" -f2 | while read f2; do
        f1="$1/$(basename $f2)"
        [[ -L "$f1" || -L "$f2"  ]] && continue

        if [[ -f "$f1" && "$(md5 -q $f1)" = "$(md5 -q $f2)" ]]; then
            st="=="
        else
            st="\033[31m ×\033[0m"
            [[ -d "$f1" ]] && st="  "
        fi

        printf "$3$st %4s $(basename $f2)\n"  "$(du -sh "$f2" | cut -f1)"
        # [ "${st:0:2}" = "==" ] && ln -sf  "$f1" "$f2"
        [ -d "$f1"           ] && fcontain "$f1"   "$f2" "$3        "
    done
    return 0
}

format() {
    i=0
    ls ~/Code/yaccai.blog/_posts/*.md | while read it; do
    printf "processing  %3d  ${it##*/}\n" "$((++i))"
    gsed "s/^layout[\ \t]*/layout    /;\
          s/^title[\ \t]*/title     /;\
          s/^date[\ \t]*/date      /;\
          s/^category[\ \t]*/category  /;\
          s/^tags[\ \t]*/tags      /;\
          s/^Published[\ \t]*/published   /"  -i "$it"
    done
}

search() { 
    app=""
    [[ "$2" == "-t" ]] && app="-exec open -a Typora {} +"
    [[ "$2" == "-s" ]] && app="-exec open -a Sublime\ Text {} +"
    [[ "$2" == "-c" ]] && app="-exec open -a Visual\ Studio\ Code.app {} +"
    sh -c "find ~/Code/yaccai.blog/_posts -iname \"*$1*\" -print $app"
    # echo "$app"
}

code=(
    UTF-8
    GBK
    GB18030
    UTF-16
    WINDOWS-1252
    ISO-8859
    )
toUTF-8() {
    for file in "${@}"; do
        ext=${file##*.}
        i=0
        for c in "${code[@]}"; do
            ((i += 1))
            iconv -f "$c" -t UTF-8 "$file" 1>"$file.UTF8.$ext" 2>/dev/null && break
        done

        if [[ $i == ${#code[@]} ]]; then
            echo "ER"
            rm $file.UTF8.$ext
            return -1
        else :
            mv "$file.UTF8.$ext" "$file"
        fi
        
    done

}

if [[ $# -eq 0 ]]; then
    exit
fi

case "$1" in
    "help" )
        echo "subcommand:"
        cat "$0" | awk  '/"[a-zA-Z\_\-\+0-9]+" \)/{print $0}' | sed 's/"//g; s/)//g'
        ;;
    "gbkenv" )
        export LANG=zh_CN.GBK
        export LC_ALL=zh_CN.GBK
        "$@"
        export LANG=zh_CN.UTF-8
        export LC_ALL=zh_CN.UTF-8
        ;;
    "cls" )
        osascript &>/dev/null <<EOF
        tell application "iTerm"
            set theWindow to current window
            tell current window
                set pretab to current tab
                set theTab to create tab with default profile
                close pretab
            end tell
        end tell
EOF
        ;;
    "newEdit" )
        touch "$2"
        case "${2##*.}" in  
            "py")   chmod +x "$2"; 
                    echo '#!/usr/local/bin/python3' >>"$2"
                    echo '# -*- coding: utf-8 -*- ' >>"$2"
                    ;;
            "sh")   chmod +x "$2"; 
                    echo '#!/bin/bash'              >>"$2"
                    echo '# coding:utf-8'           >>"$2"
                    ;;
        esac
        code "$2"; 
        ;;
    "simpleChinese" )
        opencc -c t2s.json -i "$2" -o "$2"
        ;;
    "toUTF-8" )
        toUTF-8 "${@:2}"
        ;;
    "fcontain" )              # 测试$2是否包含 $3的所有文件
        fcontain "$2" "$3"    # diff -r
        ;;
    "newBlog" )
        new "$2"
        ;;
    "buildBlog" )
        # might /usr/local/bin/gem install jekyll nokogiri jekyll-paginate
        find ~/Code/yaccai.github.io ! -regex ".*/.git.*" -type f -delete
        /usr/local/bin/jekyll build --source ~/Code/yaccai.blog --destination ~/Code/yaccai.github.io
        ;;
    "renameBlog" )             # 根据md头部的日期，更新文件名中的日期
        renameblog
        ;;
    "formatBlog" )
        format
        ;;
    "searchBlog" )
        search "${@:2}"
        ;;
    "searchPoem" )
        poemD=/Volumes/Doc/Doc/txt/诗词/
        [ -d "$poemD" ] && [ ! -z "$2" ] && (
            cd "$poemD"
            grep --colour -nHC0 "$2" *.txt
        )
        ;;
    * )
        echo "no such pattern"
        ;;
esac
