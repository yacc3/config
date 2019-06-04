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
    try:
        tc = transmissionrpc.Client('localhost', port=9091, timeout = 3)
        torlist = tc.get_torrents(timeout = 3)
    except Exception as e:
        print(e)
        return

    for t in torlist:
        if t.percentDone == 1.0 or t.sizeWhenDone < 5000000:
            tc.move_torrent_data(t.id, '/Volumes/Store/Downloads/t66ydone')
            tc.remove_torrent(t.id)
        if com.nowsec - t.addedDate > 3600*24*3 and t.percentDone < 0.3:
            tc.remove_torrent(t.id, delete_data=True)

        tf = sorted(t.files().items(), key=lambda d: d[1]['size']) # 按文件大小，升序
        if tf[-2][1]['selected'] and tf[-1][1]['name'].find('hjd2048.com_') >= 0:
            rmids = list(t.files().keys())
            rmids.remove(tf[-1][0])
            tc.change_torrent(t.id, files_unwanted = rmids)

        for k, v in tf:
            if v['selected']:
                NAME = v['name'].upper()
                if v['size'] < 80000000 or NAME.find('迷奸') >= 0 or NAME.find('直播') >= 0 or NAME.find('主播') >= 0 or NAME.find('.ZIP') >= 0 or NAME.find('.RAR') >= 0:
                    tc.change_torrent(t.id, files_unwanted = [k])


def ut_config():
    try:
        app = utorrentapi.UTorrentAPI('http://127.0.0.1:61130/gui', 'admin', 'admin')
    except Exception as e:
        print(e)
        return

    torrents = app.get_list_my().decode('utf-8')
    torrents = json.loads(torrents).get('torrents')

    for it in torrents:
        if it[-8] != 'Seeding':
            app.stop(it[0])
        # print(it[29])
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
