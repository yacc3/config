#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import os
import sys
import requests
import urllib.parse
from   lxml import html

location = '/Volumes/Bak/Backup/Model'


def get(url):
    try:
        res = requests.get(url, timeout=10)
        res = res.content if res.ok else None
    except:
        print('get error  : %s' % url)
        res = None
    return res


def pullAlbum(site, pwd = None):
    global location
    if pwd is None:
        pwd = location if os.path.exists(location) else os.getcwd()
    res = urllib.parse.urlsplit(site)
    base = res.scheme + '://' + res.netloc
    data = get(site)
    if data is None:
        return
    page = data.decode('UTF-8')
    tree = html.fromstring(page)
    page_imgs = tree.xpath('//*[@id="hgallery"]/img')   # 本页面照片
    album_name = tree.xpath('//*[@id="htilte"]')[0].text # 专辑名称
    album_path = os.path.join(pwd, album_name)
    if not os.path.exists(album_path):
        os.mkdir(album_path)
    for it in page_imgs:
        img_href = it.xpath('./@src')[0]
        img_name = urllib.parse.urlsplit(img_href).path.split('/')[-1]
        img_file = os.path.join(album_path, img_name)
        if not os.path.exists(img_file) or os.path.getsize(img_file) < 10000:
            img_data = get(img_href)
            if img_data is not None:
                with open(img_file, 'wb') as f:
                    f.write(img_data)
                print('fetch  -- >  OK  %s' % img_name)
    next = tree.xpath('//*[@id="pages"]/a')[-1]
    next = next.xpath('./@href')[0]
    if res.path.find(next) == 0:
        print('Done   %s\n' % album_path)
        pass
    else:
        nexturl = urllib.parse.urljoin(base, next)
        pullAlbum(nexturl, pwd)

def pullAll(site):
    res = urllib.parse.urlsplit(site)
    base = res.scheme + '://' + res.netloc
    page = get(site).decode('UTF-8')
    tree = html.fromstring(page)
    album_list = tree.xpath('//*[@id="photo_list"]/ul/li')     # 专辑列表的xpath
    model_name = tree.xpath('//*[@id="map"]/div/a[2]')[0].text # 模特的名字

    global location
    if not os.path.exists(location):
        location = os.getcwd()
    model_path = os.path.join(location, model_name)

    if not os.path.exists(model_path):
        os.mkdir(model_path)
    for it in album_list:
        node = it.xpath('./div[2]/a[1]')[0] # 每一个专辑
        href = node.xpath('./@href')[0]
        album_href = urllib.parse.urljoin(base, href)
        pullAlbum(album_href, model_path)
    pass


if __name__ == '__main__':
    argc = len(sys.argv)
    if argc == 3:
        if sys.argv[1] == 'all':
            pullAll(sys.argv[2])
        elif sys.argv[1] == 'album':
            pullAlbum(sys.argv[2])
    pass
