#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import requests
import re
import os
import sys
from PIL import Image
from io import BytesIO


class nvshen:
    def __init__(self):
        '''
        初始化head
        '''
        self.header_html = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': '',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 'www.nvshens.com',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36',
        }
        self.header_img = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 't1.onvshen.com:85',
            'Referer': 'https://www.nvshens.com/img.html?img=',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36'
        }
        self.proxies = {
            'http': 'http://127.0.0.1:1087',
            'https': 'http://127.0.0.1:1087',
        }
        self.Model = '/Volumes/Store/Model'
        self.server = 'https://www.nvshens.com'


    def getAlbum(self, Album_url, Model='Others'): # url => https://www.nvshens.com/g/29365/
        res = requests.get(Album_url, headers=self.header_html)

        title_pattern = re.compile('(?<=htilte\">)[^>]*(?=</h1>)')
        title = title_pattern.findall(res.text)[0]
        fpath = os.path.join(self.Model, Model, title)
        if not os.path.exists(fpath):
            os.mkdir(fpath)
            print("fetch", fpath)
        else:
            print("exist", fpath)
            return

        img_pattern = re.compile('http[^=]*?/gallery/[0-9]+/[0-9]+[/s]*/0.jpg')
        img_urlpart = img_pattern.findall(res.text)[0].replace('/s', '').replace('/0.jpg', '')
        ne = 0
        for i in range(0, 100):
            img_name = "0.jpg" if i is 0 else ("%03d.jpg" % i)
            img_url = os.path.join(img_urlpart, img_name)
            res = requests.get(img_url, headers = self.header_img)
            if res.ok:
                print("fetching  -->  ", img_name)
                Image.open(BytesIO(res.content)).save(os.path.join(fpath, img_name), 'JPEG')
                ne = 0
            else: # print('ER: ', img_name)
                ne += 1
            if ne >= 3:
                print()
                break

    
    def processModel(self, url): # url => https://www.nvshens.com/girl/22162/album/
        res = requests.get(url, headers=self.header_html)
        res.encoding='UTF-8'
        model_pattern = re.compile('(?<=/girl/[0-9]{5}/" title=").*?(?=")')
        model = model_pattern.findall(res.text)[0]

        album_pattern = re.compile("(?<=igalleryli_link' href=')/g/[0-9]{5}/(?=')")
        for album in album_pattern.findall(res.text):
            self.getAlbum(self.server + album, model)

    def processModel2(self, url): # https://www.nvshens.com/girl/27023/
        res = requests.get(url, headers=self.header_html)
        res.encoding='UTF-8'
        model_pattern = re.compile('(?<=/a> &gt; )[^<>]*?(?=</div)')
        model = model_pattern.findall(res.text)[0]

        album_pattern = re.compile("(?<=igalleryli_link' href=')[^<>']*")
        for album in album_pattern.findall(res.text):
            self.getAlbum(self.server + album, model)


if __name__ == "__main__":
    argc = len(sys.argv)
    if argc == 2:
        nv = nvshen()
        url = sys.argv[1]
        if url.find('album') == -1:
            nv.processModel2(url)
        else:
            nv.processModel(url)

# https://www.nvshens.com/girl/22162/album/
# https://www.nvshens.com/girl/17936/album/
# https://www.nvshens.com/girl/24936/album/
# https://www.nvshens.com/girl/23448/album/
# https://www.nvshens.com/girl/20763/album/
# https://www.nvshens.com/girl/25666/album/
# https://www.nvshens.com/girl/24691/album/
# https://www.nvshens.com/girl/21887/album/
# https://www.nvshens.com/girl/24986/album/
# https://www.nvshens.com/girl/23033/album/
# https://www.nvshens.com/girl/21511/album/
# https://www.nvshens.com/girl/18879/album/
# https://www.nvshens.com/girl/27023/