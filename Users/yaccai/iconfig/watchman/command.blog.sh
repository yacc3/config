#!/bin/bash
printf "\n\n%s trig -- > %s\n" "$(date +'%Y-%m-%d %T')" "$(basename $0)"
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# might /usr/local/bin/gem install jekyll nokogiri jekyll-paginate
/usr/local/bin/jekyll build --incremental --quiet --source ~/Code/yaccai.blog --destination ~/Code/yaccai.github.io
echo "    build!"
