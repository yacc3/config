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
        maxsize = 0
        maxsizesn = -1
        select_count = 0 # 记录当前种子包含的文件中，选择了几个下载？
        for k, v in t.files().items():
            if v['selected']:
                if v['size'] < 110000000 and v['completed'] < v['size']: # 除掉小文件
                    tc.change_torrent(t.id, files_unwanted = [k])
                if v['name'].upper().find('直播') >= 0:  # 除掉直播
                    tc.change_torrent(t.id, files_unwanted = [k])
                if v['name'].upper().find('.ZIP') >= 0: # 除掉zip
                    tc.change_torrent(t.id, files_unwanted = [k])
                if v['name'].upper().find('.RAR') >= 0: # 除掉rar
                    tc.change_torrent(t.id, files_unwanted = [k])
            if t.name.find('hjd2048.com_') >= 0:                      # 当前的种子是个hdj2048.com
                select_count += 1 if v['selected'] else 0
                if v['size'] > maxsize:
                    maxsize = v['size']
                    maxsizesn = k
        if select_count > 1:
            rmids = list(t.files().keys())
            rmids.remove(maxsizesn)
            tc.change_torrent(t.id, files_unwanted = rmids)

        if t.percentDone == 1.0 or t.totalSize < 5000000:
            t.stop()
            tracker = "" if len(t.trackers) == 0 else t.trackers[0]['announce']
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
