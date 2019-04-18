#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

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
        print('transmission is not running')
        return
    try:
        tc = transmissionrpc.Client('localhost', port=9091, timeout = 3)
        torlist = tc.get_torrents(timeout = 3)
    except Exception as e:
        print(e)
        return

    for t in torlist:
        tracker = t.trackers[0]['announce']
        if t.percentDone == 1.0 or t.totalSize < 5000000:
            t.stop(timeout= 1)
            if tracker.find("totheglory.im") == -1 and tracker.find("sjtu") == -1: # 不是pt种子
                tc.move_torrent_data(t.id, '/Volumes/Store/Downloads/t66ydone')
                tc.remove_torrent(t.id)
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
        return
    try:
        app = utorrentapi.UTorrentAPI('http://127.0.0.1:61130/gui', 'admin', 'admin')
    except Exception as e:
        print('ut api error')
        return

    torrents = app.get_list_my().decode('utf-8')
    torrents = json.loads(torrents).get('torrents')

    for it in torrents:
        print(it)
        # break
        # if it[-8] != 'Seeding':
        #     continue

        # stopit = True  # 已经完成但不在 location 中的，停止
        # for folder in locations:
        #     path = os.path.join(folder, it[2])
        #     if os.path.exists(path):
        #         stopit = False
        #         break
        # if stopit:
        #     app.stop(it[0])
        #     print('            stop  %s' % it[2])


if __name__ == '__main__':
    tm_config()
    # ut_config()
    pass

print('\n')
