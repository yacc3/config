#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
import os
import sys
from torrentool.api import Torrent

argc = len(sys.argv)
if argc == 1:
    exit()

for tor in  sys.argv[1:]:
    if not tor.endswith('.torrent') or not os.path.exists(tor):
        continue
    torinfo = Torrent.from_file(tor)
    print("%11s    %s" % ("", torinfo.name))
    print("%11s    %s" % ("", torinfo.total_size))
    print("%11s    %s" % ("", torinfo.info_hash))
    for it in torinfo.files:
        print("%11d    %s" % (it.length, it.name))