#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import requests
import re
import os
import sys
import time
import datetime
import pymysql

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
            'Referer': 'https://www.nvshens.net/g/29580',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
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
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36'
        }
        self.proxies = {
            'http': 'http://127.0.0.1:1087',
            'https': 'http://127.0.0.1:1087',
        }
        self.force = False
        self.Model = '/Volumes/Store/Model'
        self.server = 'https://www.nvshens.com'
        self.stmp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        self.db = None
        try:
            self.db = pymysql.connect("localhost","yaccai","go","daily" )
        except Exception as e:
            print(e)


    def __del__(self):
        if self.db is not None:
            self.db.close() 


    def getAlbum(self, Album_url, Model='Others'): # url => https://www.nvshens.com/g/29365/
        res = requests.get(Album_url) #, headers=self.header_html)
        title_pattern = re.compile('(?<=htilte\">)[^>]*(?=</h1>)')
        title = title_pattern.findall(res.text)[0]
        
        print("fetch  ", Album_url)
        fpath = os.path.join(self.Model, Model, title) # 目录 名字 专辑名
        print('        %s' % fpath + '/')
        if not os.path.exists(fpath):
            os.makedirs(fpath)
        elif not self.force:
            return

        img_pattern = re.compile('http[^=]*?/gallery/[0-9]+/[0-9]+[/s]*/0.jpg')
        img_urlpart = img_pattern.findall(res.text)[0].replace('/s', '').replace('/0.jpg', '')
        
        num_pattern = re.compile('(?<=>)[0-9]+(?=张照片</span>)')
        num = int(num_pattern.findall(res.text)[0])
        print('        %d 张' % num)
        
        args = []
        for i in range(0, num):
            args.append((img_urlpart, i, fpath))
        with ThreadPoolExecutor(max_workers = 20) as executor:
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
        except: # Exception as e:
            print('\033[31mx\033[0m       ==>  %s' % img_url)
            # print(e)
        if res.ok:
            img = Image.open(BytesIO(res.content))
            img.save(img_file, 'JPEG')
            print('\033[32m√\033[0m       ==>  %7s  %4d x %4d  %5.1f KB  %5.2f s' % (img_name, img.width, img.height, len(res.content)/1024, res.elapsed.microseconds/1000000))        


    def processModel(self, url, update = False): # https://www.nvshens.com/girl/22162/album/
        print()
        res = requests.get(url) #, headers=self.header_html)
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

        try:
            model = model_pattern.findall(res.text)[0]
            album_list = album_pattern.findall(res.text)
        except:
            print("fail    %s" % url)
            return

        album_count = len(album_list)
        i = 0
        for album in album_list:
            i += 1
            print('Album   %d/%d' % (i, album_count))
            self.getAlbum(self.server + album, model)
            if update and i >= 1: # 更新模式只下载前面就可以了
                break
    

    def insert(self, string):
        modelid_pattern = re.compile('(?<=/girl/)[0-9]{5}')
        modelid = modelid_pattern.findall(string)
        if len(modelid) == 0:
            print('没有找到合适的 模式 /girl/[0-9{5}]')
            return
        modelid = int(modelid[0])
        print('insert', modelid)
        cursor = self.db.cursor()
        cursor.execute("select count(*) from model where modelid = %d" % modelid)
        if cursor.fetchone()[0] > 0:
            print('id 已经存在')
            return
        sql_insert = "insert into model values(DEFAULT, '%s', '%d')" % (self.stmp, modelid)
        cursor.execute(sql_insert)
        self.db.commit()


    def delete(self, string):
        modelid_pattern = re.compile('[0-9]{5}')
        modelid = modelid_pattern.findall(string)
        if len(modelid) == 0:
            print('没有找到合适的 model id')
            return
        modelid = int(modelid[0])
        cursor = self.db.cursor()
        cursor.execute("delete from model where modelid = %d" % modelid)
        self.db.commit()


if __name__ == "__main__":
    argc = len(sys.argv)
    if argc >= 2:
        nv = nvshen()
        cmd = sys.argv[1]
        if   cmd == 'update':
            cursor = nv.db.cursor()
            cursor.execute("select * from model")
            for it in cursor.fetchall():
                nv.processModel('https://www.nvshens.com/girl/%s/album/' % it[2], update = True)
        elif cmd == 'insert':
            nv.insert(sys.argv[2])
        elif cmd == 'delete':
            nv.delete(sys.argv[2])
        else: # 常规抓取
            if argc == 3 and sys.argv[2] == 'force':
                nv.force = True
            nv.processModel(sys.argv[1])
