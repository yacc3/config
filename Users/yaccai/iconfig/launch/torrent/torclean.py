#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
exit()
import os
import sys
import time
import common  as com


print('torclean  @ ' + com.nowstr + ' ...')

disk_revz = 120


def getAtimeList(location):
    L = []
    for it in os.listdir(location):
        entry = os.path.join(location, it)
        if it.startswith('._'):
            continue
        maxact = os.path.getatime(entry)
        for root, dirs, files in os.walk(entry):
            for f in files:
                fpath = os.path.join(root, f)
                if f.startswith('._'):
                    continue
                maxact = max(maxact, os.path.getatime(fpath))
        L.append((maxact, it))
    return sorted(L, key=lambda tup: tup[0])


def getrevz():
    disk = os.statvfs(com.mainDir)
    return disk.f_bsize * disk.f_bavail / 1000000000.0


def cleanbyAtime():
    print("            %d GB" % getrevz())
    if getrevz() < disk_revz and os.path.exists(path):
        for t in getAtimeList(com.mainDir):
            if com.checkKeys(name, com.clean_block):
                continue
            title = t[1]
            path = os.path.join(com.mainDir, title)
            if getrevz() < disk_revz and os.path.exists(path):
                print("            %s" %  title)
                os.system('rm -rf "%s"' % path)
                os.system("sync;sync")
                # break # 一次只删除一个 10分钟一次检查
    print("            %d GB" % getrevz())


def showList():
    list = getAtimeList(com.mainDir)
    for t in list:
        tstr = time.strftime('%m-%d %H:%M',time.localtime(t[0]))
        print("%s  %s" % (tstr, t[1]))



if __name__ == '__main__':
    argc = len(sys.argv)
    if argc == 1:
        print('subcommand:  remove | list')
    elif argc == 2:
        if sys.argv[1] == 'remove':
            cleanbyAtime()
            print('\n')
        elif sys.argv[1] == 'list':
            showList()
