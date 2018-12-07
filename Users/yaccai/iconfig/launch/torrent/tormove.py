#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
exit()
import os
import sys
import common  as com
import transmissionrpc
from torrentool.api import Torrent

print('tormove   @ ' + com.nowstr + ' ...')

vuzescpt = os.path.join(os.environ['HOME'], 'iconfig/launch/torrent/torvuze.sh')
vuzetodo = '/Volumes/Doc/Downloads/todo'
os.system('mkdir -p %s' % vuzetodo)

def vuze_done_move():
    res = os.popen("ps aux | grep '[%s]%s'" % (vuzescpt[0], vuzescpt[1:])).readlines()
    if len(res) != 0:
        return

    L = []
    for it in os.listdir(vuzetodo):
        if not it.endswith('.torrent') or it.startswith('.'):
            continue
        
        seed_file = os.path.join(vuzetodo, it)
        torrent_info = Torrent.from_file(seed_file)
        tpath = os.path.join('/Volumes/Doc/Downloads/complete', torrent_info.name)
        if torrent_info.announce_urls[0][0].find('totheglory.im') < 0:
            continue
        
        all_exists = True # 避免重复下载了已有的种子，再次传输到主磁盘
        for fit in torrent_info.files:
            if not os.path.exists(os.path.join('/Volumes/Store/Torrent', fit[0])):
                all_exists = False
                break
        if not all_exists and os.path.exists(tpath):
            print('add', torrent_info.name)
            L.append((tpath, seed_file, torrent_info.total_size, torrent_info.name))
            torrent_info.announce_urls = []
            torrent_info.to_file(os.path.join('/Volumes/Doc/Downloads/cheat', torrent_info.name + '.torrent'))

    if len(L) > 0:
        f = open('/tmp/vuzetext', 'w', encoding='utf-8')
        for it in L:
            str = '%s###%s###%d###%s\n' % (it[0], it[1], it[2], it[3])
            f.write(str)
        f.close()
        os.system('open -ga iTerm %s' % vuzescpt)


def tran_done_move():
    try:
        tc = transmissionrpc.Client('localhost', port=9091, timeout = 3)
        torlist = tc.get_torrents(timeout = 3)
    except Exception as e:
        print('error on init tc')
        return

    for t in torlist:
        if  t.trackers[0]['announce'].find("im") >= 0 and t.status == 'seeding' and t.downloadDir != '/Volumes/Store/Torrent' and t.maxConnectedPeers != 113:
            os.system('cp -rf "%s" %s' % (t.torrentFile.replace('amp;', ''), vuzetodo))
            t.stop()



if __name__ == '__main__':
    # tran_done_move()
    vuze_done_move()
    pass
print('\n')
