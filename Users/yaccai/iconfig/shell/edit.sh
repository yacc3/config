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
    subl                        "$file"
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
    [[ "$2" == "-t" ]] && app="Typora"
    [[ "$2" == "-s" ]] && app="Sublime\ Text"
    [[ "$2" == "-c" ]] && app="Visual\ Studio\ Code.app"
    sh -c "find ~/Code/yaccai.blog/_posts -iname \"*$1*\" -print -exec open -a $app {} +"
}



if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  "/\"[a-zA-Z\_\-\+]+\" \)/{print $1}" | sed "s/\"//g; s/)//g"
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
    "iTermClean" )
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
    "transcode" )
        ~/iconfig/exe/transCode.sh "${@:2}"
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
    "newBlog" )
        new "$2"
        ;;
    "buildBlog" )
        # might /usr/local/bin/gem install jekyll nokogiri jekyll-paginate
        find ~/Code/yaccai.github.io ! -regex ".*/.git.*" -type f -delete
        /usr/local/bin/jekyll build --source ~/Code/yaccai.blog --destination ~/Code/yaccai.github.io
        ;;
    "renameBlog" ) # 根据md头部的日期，更新文件名中的日期
        renameblog
        ;;
    "formatBlog" )
        format
        ;;
    "searchBlog" )
        search "${@:2}"
        ;;
    * )
        echo "no such pattern"
        ;;
esac
