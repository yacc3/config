#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import os
import time
import base64
import datetime

import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.detach(), encoding='utf-8')  
sys.stderr = io.TextIOWrapper(sys.stderr.detach(), encoding='utf-8')

nowsec = time.time()
nowstr = datetime.datetime.now().strftime('%Y-%m-%d %T')
tgcook = '__cfduid=d7802accde8beea09e87218239ea189ee1509495772; UM_distinctid=15f74f5e393346-06303d0c19109c-193e6d56-100200-15f74f5e3941da; __utmz=230798618.1509495792.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.2.690470405.1509495792; uid=143329; pass=aa12c5551bdf274a034d1c5547c28e58; laccess=1522146665; PHPSESSID=7u6m2t1uv31e3jsb3d8burmfk3; __utmc=230798618; _gid=GA1.2.629291538.1523619543; __utma=230798618.690470405.1509495792.1523682968.1523697785.57; CNZZDATA4085974=cnzz_eid%3D1400608048-1509494220-https%253A%252F%252Ftotheglory.im%252F%26ntime%3D1523698580; __utmt=1; __utmb=230798618.38.10.1523697785; _gat=1'

tgserver = 'https://totheglory.im'
tgTorURL = os.path.join(tgserver, 'browse.php?c=M')
mainDir = '/Volumes/Store/Torrent'  # OS == "Darwin"

favortg = [
    ['Ruyi', 'Royal',' Love', 'Palace'],
    ['Story', 'Yanxi', 'Palace'],
    ['グッド・ドクター'],
    ['この世界の片隅に'],
    ['高嶺の花'],
    ['Missデビル～人事の悪魔・椿眞子'],
    ['義母と娘のブルース'],
    ['連続テレビ小説 半分、青い'],
    ['絶対零度～未然犯罪潜入捜査'],
    ['ドラマＢｉｚ「ラストチャンス～再生請負人～」']
] # + favor_commonHot


clean_block = [  # 自动删除时，避开
    ['Story', 'Yanxi'],
    ['大明王朝'],
    ['走向共和'],
    ['Harry']
]


blocktg = [ # 自动下载时，避开
    ['-ARiN'],
    ['HNTV'],
    ['Countdown'],
    ['JuJuYuJu'],
    ['Gifted', 'HDTV'],
    ['Fargo', 'S02', '2015'],
    ['The', 'In-Laws', 'HDTV'],
    ['Partners', 'for', 'Justice'],
    ['Reach', 'For', 'The', 'Skies'],
    ['Eine', 'deutsche', 'Chronik', '1984', 'PartI']
]


def checkKeys (title, Keys):
    title = title.upper()
    for item in Keys:
        isMatch = len(item) > 0
        for key in item:
            key = key.upper()
            if title.find(key) == -1:
                isMatch = False
                break
        if isMatch == True:
            return True
    return False






if __name__ == '__main__':
    pass
