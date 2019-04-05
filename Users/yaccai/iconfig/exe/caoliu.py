#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import requests
import re
import os
import threading

class Caoliu:
    def __init__(self):
        '''
        初始化定义一个请求头，后面省的重复定义。同时创建存种子的文件夹
        '''
        self.header_data = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': '',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 'www.t66y.com',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36',
        }
        self.proxies = {
            'http': 'http://127.0.0.1:1087',
            'https': 'http://127.0.0.1:1087',
        }
        # self.torrent_dir = os.environ['HOME']
        self.html_dir = '/Volumes/Store/Torrent/XV/t66y_html'
        self.torrent_dir = os.path.join(os.environ['HOME'], 'Downloads')

    def download_page(self, url):
        '''
        针对草榴的第三级页面的方法，负责下载链接
        '''
        header_data2 = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 'rmdown.com',
            'Referer': 'http://www.viidii.info/?http://rmdown______com/link______php?' + url.split("?")[1],
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36'
        }
        try:
            download_text = requests.get(url, headers=header_data2, proxies=self.proxies).text
            p_ref = re.compile("name=\"ref\" value=\"(.+?)\"")#点击下载时会有表单提交，几个参数都是页面内hidden属性的值，把他们先提取出来
            p_reff = re.compile("NAME=\"reff\" value=\"(.+?)\"")
            ref = p_ref.findall(download_text)[0]
            reff = p_reff.findall(download_text)[0]
            torrent_file=os.path.join(self.torrent_dir, ref + ".torrent")

            r = requests.get("http://www.rmdown.com/download.php?ref="+ref+"&reff="+reff+"&submit=download", proxies=self.proxies)
            with open(torrent_file, "wb") as f:
                f.write(r.content) #下载种子到文件
                print('store torrent: ', ref)
        except:
            print("download page " + url + " failed")

    def index_page(self, fid=2, offset=1):
        '''
        针对草榴的第一级页面(浏览帖子题目的页面)
        '''
        p = re.compile("<h3><a href=\"(htm_data.+?)\"")
        try:
            tmp_url = "http://www.t66y.com/thread0806.php?fid=" + str(fid) + "&search=&page=" + str(offset)
            r = requests.get(tmp_url, proxies=self.proxies)
            for i in p.findall(r.text): # 用i做缓存的标记
                html_name=os.path.join(self.html_dir, i.split('/')[-1])
                if not os.path.exists(html_name):
                    self.detail_page(i)
                    with open(html_name, 'w'):
                        pass
        except:
            print("index page " + str(offset) + " get failed")

    def detail_page(self, url):
        '''
        针对具体一个帖子，提取其中的绿色链接(给网盘链接的太不厚道了)
        '''
        p1 = re.compile("(http://rmdown.com/link.php.+?)<")
        p2 = re.compile("(http://www.rmdown.com/link.php.+?)<")
        base_url = "http://www.t66y.com/"
        try:
            r = requests.get(url=base_url + url, headers=self.header_data, proxies=self.proxies)
            url_set = set()
            for i in p1.findall(r.text):
                url_set.add(i)
            for i in p2.findall(r.text):
                url_set.add(i)
            url_list = list(url_set)
            for i in url_list:
                self.download_page(i)
        except:
            print("detail page " + url + " get failed")

    def start(self, type, page_start=1, page_end=1):
        '''
        启动方法，其中type参数负责类型
        下载类型 | type
        -------- | -------
        亚洲无码 | yazhouwuma
        亚洲有码 | yazhouyouma
        欧美原创 | oumeiyuanchuang
        动漫原创 | dongmanyuanchuang
        国产原创 | guochanyuanchuang
        中字原创 | zhongziyuanchuang
        page_start,page_end代表起始页和终止页 max_thread_num代表允许程序使用的最大线程数
        '''

        if type == "yazhouwuma":
            fid = 2
        elif type == "yazhouyouma":
            fid = 15
        elif type == "oumeiyuanchuang":
            fid = 4
        elif type == "dongmanyuanchuang":
            fid = 5
        elif type == "guochanyuanchuang":
            fid = 25 # fid 是类型码
            # print('国产原创')
        elif type == "zhongziyuanchuang":
            fid = 26
        else:
            raise ValueError("type wrong!")
    
        for i in range(page_start, page_end + 1):
            self.index_page(fid, i)

if __name__ == "__main__":
    c = Caoliu()
    c.start(type="guochanyuanchuang",page_start = 1, page_end = 1)