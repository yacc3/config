#!/bin/zsh
# coding:utf-8

new() {
    [[ -z "$1" ]] && return
    echo "create new blog: $1"
    date=`/bin/date +%Y-%m-%d`
    file=/Volumes/Store/Code/yacc3.github.src/_posts/"${date}-$1.md"

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
    ls /Volumes/Store/Code/yacc3.github.src/_posts/*.md | while read it; do
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
    ls /Volumes/Store/Code/yacc3.github.src/_posts/*.md | while read it; do
    printf "processing  %3d  ${it##*/}\n" "$((++i))"
    gsed "s/^layout[\ \t]*/layout    /;\
          s/^title[\ \t]*/title     /;\
          s/^date[\ \t]*/date      /;\
          s/^category[\ \t]*/category  /;\
          s/^tags[\ \t]*/tags      /;\
          s/^Published[\ \t]*/published   /"  -i "$it"
    done
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
    echo "subcommand:"
    cat "$0" | awk  '/"[a-zA-Z_\-\+0-9]+" \)/{print $0}' | sed 's/"//g; s/)//g'
    exit
fi

case "$1" in
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
            "tex")  
                    echo '\\documentclass{article}'  >>"$2"
                    echo '\\usepackage{fancyhdr}'    >>"$2"
                    echo '\\usepackage{ctex}'        >>"$2"
                    echo '\\usepackage{tabularx}\n'  >>"$2"
                    echo '\\pagestyle{fancy}'        >>"$2"
                    echo '\\cfoot{}\n'               >>"$2"
                    echo '\\begin{document}\n\n'     >>"$2"
                    echo '%\\begin{tabular}{llll}'   >>"$2"
                    echo '%\\end{tabular}'           >>"$2"
                    echo '\\end{document}'           >>"$2"
                    ;;
        esac
        code "$2"; 
        ;;
    "2cht" )                    # 转化为简体
        opencc -c s2t.json <<< "$2"
        ;;
    "2chs" )                    # 转化为简体
        for it in "${@:2}"; do
            opencc -c t2s.json -i "$2" -o "${it/cht\./chs.}" && echo "done  $it"
        done
        ;;
    "utf8" )
        toUTF-8 "${@:2}"
        ;;
    "fcontain" )               # 测试$2是否包含 $3的所有文件
        fcontain "$2" "$3"     # diff -r
        ;;
    "gitpush" )                # 推送 默认master
        git add .
        git commit -m "$(date +'%Y-%m-%d %T')"
        git push origin "${2:-master}"
        ;;
    "newBlog" )
        new "$2"
        ;;
    "buildBlog" )
        jekyll build -s /Volumes/Store/Code/yacc3.github.src -d /Volumes/Store/Code/yacc3.github.io
        ;;
    "serveBlog" )
        jekyll serve -s /Volumes/Store/Code/yacc3.github.src -d /Volumes/Store/Code/yacc3.github.io --watch
        ;;
    "pushBlog" )
        jekyll build -s /Volumes/Store/Code/yacc3.github.src \
                     -d /Volumes/Store/Code/yacc3.github.io
        # tar -cJf src.xz \
        #         --exclude='css' \
        #         --exclude='img' \
        #         --exclude='js' \
        #         -C /Volumes/Store/Code/yacc3.github.io ../yacc3.github.src
        git -C /Volumes/Store/Code/yacc3.github.io add .
        git -C /Volumes/Store/Code/yacc3.github.io commit -m "$(date +'%Y-%m-%d %T')"
        git -C /Volumes/Store/Code/yacc3.github.io push origin "${2:-master}"
        ;;
    "renameBlog" )             # 根据md头部的日期，更新文件名中的日期
        renameblog
        ;;
    "formatBlog" )
        format
        ;;
    "findBlog" )
        app=""
        [[ "$3" == "-t" ]] && app="-exec open -a Typora {} +"
        [[ "$3" == "-s" ]] && app="-exec open -a Sublime\ Text {} +"
        [[ "$3" == "-c" ]] && app="-exec open -a Visual\ Studio\ Code.app {} +"
        sh -c "find /Volumes/Store/Code/yacc3.github.src/_posts -iname \"*$2*\" -and -not -name '._*' -print $app"
        ;;
    "searchPoem" )
        poemD=/Volumes/Store/Doc/诗词/
        [ -d "$poemD" ] && [ ! -z "$2" ] && (
            cd "$poemD"
            grep --colour -nHC0 "$2" *.txt
        )
        ;;
    * )
        echo "no such pattern"
        ;;
esac
