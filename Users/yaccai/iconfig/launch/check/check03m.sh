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
    # valid types are ‘findutils-default’, ‘awk’, ‘egrep’, ‘ed’, ‘emacs’, ‘gnu-awk’, ‘grep’, ‘posix-awk’, ‘posix-basic’, ‘posix-egrep’, ‘posix-extended’, ‘posix-minimal-basic’, ‘sed’.
    # 正则 种类 https://www.gnu.org/software/findutils/manual/html_node/find_html/Regular-Expressions.html#Regular-Expressions
}


./douyin.py 75382141971 > ll.tmp
if [[ -f 'll.log' ]]; then
    diff ll.tmp ll.log &>/dev/null || {
        say ' , go to check ll'
        cp ll.log ~/Desktop/ll.$(date +'%H-%M-%S').log
    }
fi
mv ll.tmp ll.log

./douyin.py 9330557830 > wd.tmp
if [[ -f 'wd.log' ]]; then
    diff wd.tmp wd.log &>/dev/null || {
        say ' , go to check wd'
        cp wd.log ~/Desktop/wd.$(date +'%H-%M-%S').log
    }
fi
mv wd.tmp wd.log

echo "done"
echo
