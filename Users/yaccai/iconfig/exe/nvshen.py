#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import requests
import re
import os
import sys
import datetime

from PIL                import Image
from io                 import BytesIO
from concurrent.futures import ThreadPoolExecutor


class nvshen:
    def __init__(self):
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
        self.models = set([
            'https://www.nvshens.com/girl/22162/album/',
            'https://www.nvshens.com/girl/17936/album/',
            'https://www.nvshens.com/girl/24936/album/',
            'https://www.nvshens.com/girl/23448/album/',
            'https://www.nvshens.com/girl/20763/album/',
            'https://www.nvshens.com/girl/25666/album/',
            'https://www.nvshens.com/girl/24691/album/',
            'https://www.nvshens.com/girl/21887/album/',
            'https://www.nvshens.com/girl/24986/album/',
            'https://www.nvshens.com/girl/23033/album/',
            'https://www.nvshens.com/girl/21511/album/',
            'https://www.nvshens.com/girl/18879/album/'
        ])


    def getAlbum(self, Album_url, Model='Others'): # url => https://www.nvshens.com/g/29365/
        res = requests.get(Album_url, headers=self.header_html)

        title_pattern = re.compile('(?<=htilte\">)[^>]*(?=</h1>)')
        title = title_pattern.findall(res.text)[0]
        fpath = os.path.join(self.Model, Model, title)
        if not os.path.exists(fpath):
            os.makedirs(fpath)
        print("fetch  ", Album_url)

        img_pattern = re.compile('http[^=]*?/gallery/[0-9]+/[0-9]+[/s]*/0.jpg')
        img_urlpart = img_pattern.findall(res.text)[0].replace('/s', '').replace('/0.jpg', '')
        
        num_pattern = re.compile('(?<=>)[0-9]+(?=张照片</span>)')
        num = int(num_pattern.findall(res.text)[0])
        print('%d 张   %s' % (num, fpath + '/'))
        
        args = []
        for i in range(0, num):
            args.append((img_urlpart, i, fpath))

        with ThreadPoolExecutor(max_workers = 5) as executor:
            executor.map(lambda p: self.getimg(*p), args)

        print("done   ", fpath + '/\n')


    def getimg(self, img_urlpart, i, img_dir):
        img_name = "0.jpg" if i is 0 else ("%03d.jpg" % i)
        img_file = os.path.join(img_dir, img_name)
        if os.path.exists(img_file):
            print('exists  ==>  %7s' % img_name)
            return

        img_url  = os.path.join(img_urlpart, img_name)
        try:
            res = requests.get(img_url, headers = self.header_img, timeout = 5)
        except Exception as e:
            print('x       ==>  %s' % img_url)
            # print(e)
        if res.ok:
            img = Image.open(BytesIO(res.content))
            img.save(img_file, 'JPEG')
            print('√       ==>  %7s  %4d x %4d  %5.1f KB  %5.2f s' % (img_name, img.width, img.height, len(res.content)/1024, res.elapsed.microseconds/1000000))        


    def processModel(self, url):       # https://www.nvshens.com/girl/22162/album/
        res = requests.get(url, headers=self.header_html)
        res.encoding='UTF-8'

        if url.find('/g/') >= 0:       # https://www.nvshens.com/g/23951/
            self.getAlbum(url)
            return
        elif url.find('/album/') >= 0: # https://www.nvshens.com/girl/22162/album/
            model_pattern = '(?<=/girl/[0-9]{5}/" title=").*?(?=")'
            album_pattern = "(?<=igalleryli_link' href=')/g/[0-9]{5}/(?=')"
        else:                          # https://www.nvshens.com/girl/26982/
            model_pattern = '(?<=/a> &gt; )[^<>]*?(?=</div)'
            album_pattern = "(?<=igalleryli_link' href=')[^<>']*"

        model_pattern = re.compile(model_pattern)
        album_pattern = re.compile(album_pattern)

        model = model_pattern.findall(res.text)[0]
        album_list = album_pattern.findall(res.text)
        album_count = len(album_list)
        i = 0
        for album in album_list:
            i += 1
            print('Album   %d/%d' % (i, album_count))
            self.getAlbum(self.server + album, model)


if __name__ == "__main__":
    argc = len(sys.argv)
    if argc >= 2:
        nv = nvshen()
        if sys.argv[1] == 'update':
            for url in nv.models:
                nv.processModel(url)
        else:
            nv.processModel(sys.argv[1])
