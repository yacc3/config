#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
exit()


import os
import sys
import json
import time
import utorrentapi
import common as com
import transmissionrpc

print('torload   @ ' + com.nowstr + ' ...')

def tm_config():
    if os.system('pgrep Transmission &>/dev/null') != 0:
        # print('transmission is not running')
        return
    try:
        tc = transmissionrpc.Client('localhost', port=9091, timeout = 3)
        torlist = tc.get_torrents(timeout = 3)
    except Exception as e:
        # print('transmission rpc error')
        return

    for t in torlist:
        if t.status == 'seeding':
            t.stop(timeout= 1)
    # for t in torlist:
    #     if t.trackers[0]['announce'].find("im") >= 0:
    #         t.download_limit = 2500
    #     else:
    #         t.priority = 'low'
    #         t.upload_limit = 15
    #         if t.status == 'seeding':
    #             t.stop(timeout= 1)
    #             pass


def ut_config():
    if os.system('pgrep uTorrent &>/dev/null') != 0:
        # print('uTorrent is not running')
        return
    try:
        app = utorrentapi.UTorrentAPI('http://127.0.0.1:61130/gui', 'admin', 'admin')
    except Exception as e:
        print('ut api error')
        return

    locations = [
        '/Volumes/Store/Torrent',
        '/Volumes/Store/TorrentR',
        '/Volumes/Googol/Torrent',
        '/Volumes/Googol/TorrentR'
    ]
    torrents = app.get_list_my().decode('utf-8')
    torrents = json.loads(torrents).get('torrents')

    for it in torrents:
        if it[-8] != 'Seeding':
            continue

        stopit = True  # 已经完成但不在 location 中的，停止
        for folder in locations:
            path = os.path.join(folder, it[2])
            if os.path.exists(path):
                stopit = False
                break
        if stopit:
            app.stop(it[0])
            print('            stop  %s' % it[2])


if __name__ == '__main__':
    tm_config()
    ut_config()
    pass

print('\n')
