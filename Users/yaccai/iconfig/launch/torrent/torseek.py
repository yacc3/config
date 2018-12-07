#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
import os
import sys, io

def create_seek_data(seed_file, torDir):
    if not os.path.exists(seed_file):
        print('invalid torrent file')
        return

    from torrentool.api import Torrent
    torrent_info = Torrent.from_file(seed_file)

    print('seek for %s' % torrent_info.name)
    for it in torrent_info.files:
        fit = os.path.join('/tmp', it[0])
        pname, fname = os.path.split(fit)
        if not os.path.exists(pname):
            os.makedirs(pname)
        with open(fit, 'wb') as f:
            f.seek(max(0, it[1] - 1))
            f.write(b'\x00')

    entry = os.path.join('/tmp', torrent_info.name)
    os.system('rsync -avhP --size-only --bwlimit=32000 "%s" "%s"' % (entry, torDir))



if __name__ == '__main__':
    torDir = '/Volumes/Doc/Torrent/Cheat'
    if len(sys.argv) > 1:
        seed_file = sys.argv[1]
        if len(sys.argv) > 2:
            torDir = sys.argv[2]
        create_seek_data(sys.argv[1], torDir)

