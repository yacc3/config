#!/bin/bash
# coding:utf-8

/bin/date +'model @ %Y-%m-%d %T ...'

test -d /Volumes/Store/Model || exit 0
for url in  https://www.nvshens.com/girl/22162/album/ \
            https://www.nvshens.com/girl/17936/album/ \
            https://www.nvshens.com/girl/24936/album/ \
            https://www.nvshens.com/girl/23448/album/ \
            https://www.nvshens.com/girl/20763/album/ \
            https://www.nvshens.com/girl/25666/album/ \
            https://www.nvshens.com/girl/24691/album/ \
            https://www.nvshens.com/girl/21887/album/ \
            ; do
    ~/iconfig/shell/media.sh nvshens "$url" &>/dev/null
done

echo "done"
echo