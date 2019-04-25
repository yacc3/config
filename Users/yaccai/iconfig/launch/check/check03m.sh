#!/bin/zsh
# coding:utf-8

/bin/date +'check @ %Y-%m-%d %T ...'

test -d /Volumes/Store && {
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -iname '*.zip' -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -iname '*.rar' -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -size -100M    -delete
    /usr/local/bin/gfind /Volumes/Store/Downloads/t66ydone -type f -size +100M -print0 | /usr/local/bin/gxargs -0 -I {} mv {} /Volumes/Store/Torrent/10V
    /usr/local/bin/gfind /Volumes/Store -maxdepth 1        -type f -size +100M -print0 | /usr/local/bin/gxargs -0 -I {} mv {} /Volumes/Store/Torrent/10V
    
    # /usr/local/bin/gfind /Volumes/Store/Torrent/10V/t66y_html -regextype "egrep" -regex ".*/[0-9]{7}\.html" -ctime +3 -delete
    # validen types are ‘findutils-default’, ‘awk’, ‘egrep’, ‘ed’, ‘emacs’, ‘gnu-awk’, ‘grep’, ‘posix-awk’, ‘posix-basic’, ‘posix-egrep’, ‘posix-extended’, ‘posix-minimal-basic’, ‘sed’.
    # 正则 种类 https://www.gnu.org/software/findutils/manual/html_node/find_html/Regular-Expressions.html#Regular-Expressions
}

/usr/local/bin/fping fping -t 50 www.douyin.com && {
    stmp=$(date +'%Y-%m-%d_%H-%M-%S')
    iden=(75382141971 9330557830)
    name=(ll          wd)
    for i in $(seq 1 $#iden); do
        ./douyin.py $iden[i] > $name[i].tmp
        if [[ -f $name[i].log ]]; then
            diff $name[i].tmp $name[i].log &>/dev/null || {
                say "check $name[i]"
                mv $name[i].log $name[i].$stmp.log
                touch ~/Desktop/$name[i].${stmp:11}
            }
        fi
        mv $name[i].tmp $name[i].log
    done
}


echo "done"
echo
