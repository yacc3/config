#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 

import requests
import time
import re
import os
import pymysql


class Caoliu:
    def __init__(self):
        self.header_data = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': '',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 'www.t66y.com',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
        }
        self.proxies = {
            'http': 'http://127.0.0.1:1087',
            'https': 'http://127.0.0.1:1087',
        }

        self.home = os.environ['HOME']
        self.html_dir = '/Volumes/Store/Torrent/10V/t66y_html'
        self.torrent_dir = os.path.join(os.environ['HOME'], 'Library/Application Support/Transmission/watch') # uTorrent

        self.titleInterest = {
            15: [ # fid = 15 亚洲有码区的 兴趣关键词
                '國產',
                '西野翔', '本田岬', '三上悠亚',
                '九重环奈', '九重かんな', '明日花绮罗', '明日花キララ',
                '高桥圣子', '高橋しょう子', '希志爱野', '希志あいの',
                '彩美旬果', 'あやみ旬果', '上原亚衣', '上原亜衣',
                '小岛南', '小島みなみ', '铃春爱里', '鈴村あいり',
                '水卜樱', '水卜さくら'
            ],
            25: [ # fid = 25 国产原创区
                ''
            ]
        }
        self.titleInterest[26] = self.titleInterest[15] # 中字原创区
        self.titleInterest[27] = self.titleInterest[15] # 转帖交流区
        
        self.stmp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        self.db = None
        try:
            self.db = pymysql.connect("localhost","yaccai","go","daily" )
        except Exception as e:
            print(e)

        # try: # 测试能否连通
        #     r = requests.get(url='http://t66y.com', headers=self.header_data, proxies=self.proxies, timeout=2)
        # except Exception as e:
        #     print(e)
        #     exit()
        # if not r.ok:
        #     exit()        
        


    def __del__(self):
        if self.db is not None:
            self.db.close()        


    def check_it_Exists(self, table, it):
        try:
            cur = self.db.cursor()
            cur.execute("select count(*) from %s where string = '%s'" % (table, it))
            if cur.fetchone()[0] > 0:  # count聚合 不会返回None，至少是0
                # print('skip           ', it)
                return True
            cur.execute("insert into %s values(DEFAULT, '%s', '%s')" % (table, self.stmp, it))
            self.db.commit()
        except Exception as e:
            print(e)
        return False # 默认不存在


    def download_page(self, url):
        header_data2 = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 'rmdown.com',
            'Referer': 'http://www.viidii.info/?http://rmdown______com/link______php?' + url.split("?")[1],
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36'
        }
        try:
            download_text = requests.get(url, headers=header_data2, proxies=self.proxies).text
            p_ref = re.compile("name=\"ref\" value=\"(.+?)\"")
            p_reff = re.compile("NAME=\"reff\" value=\"(.+?)\"")
            ref = p_ref.findall(download_text)[0]
            if self.check_it_Exists('refs', ref):
                return
            reff = p_reff.findall(download_text)[0]
            torrent_file=os.path.join(self.torrent_dir, ref + ".torrent")
            r = requests.get("http://www.rmdown.com/download.php?ref="+ref+"&reff="+reff+"&submit=download", proxies=self.proxies)
            with open(torrent_file, "wb") as f:
                f.write(r.content) #下载种子到文件
                print('store torrent: ', ref)
        except Exception as e:
            print("download page " + url + " failed")
            print(e)


    def index_page(self, fid=2, offset=1):
        p = re.compile("<h3><a href=\"(htm_data[^<]+?)</a>")
        t = re.compile("padding-left:8px(.*?)</h3>")
        try:
            tmp_url = "http://www.t66y.com/thread0806.php?fid=" + str(fid) + "&search=&page=" + str(offset)
            r = requests.get(tmp_url, proxies=self.proxies)
            r.encoding='gbk'
            html = r.text.replace('\r', '').replace('\n', '')
            for it in t.findall(html): # 用i做缓存的标记
                for key in self.titleInterest[fid]:
                    if it.upper().find(key) >= 0: 
                        res = p.findall(it)
                        url = None if len(res) == 0 else res[0].split('\"')[0]
                        if url is None or self.check_it_Exists('html', url):
                            continue
                        self.detail_page(url)
                        break
        except Exception as e:
            print("index page " + str(offset) + " get failed")
            print(e)


    def detail_page(self, url):
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
        elif type == "zhongziyuanchuang":
            fid = 26
        elif type == "zhuantiejieliuqu":
            fid = 27
        else:
            raise ValueError("type wrong!")
    
        for i in range(page_start, page_end + 1):
            self.index_page(fid, i)


if __name__ == "__main__":
    if os.path.exists('/Volumes/Store'):
        c = Caoliu()
        c.start(type="guochanyuanchuang",page_start = 1, page_end = 1)
        # c.start(type="yazhouyouma",      page_start = 1, page_end = 1)
        # c.start(type="zhongziyuanchuang",page_start = 1, page_end = 1)
        c.start(type="zhuantiejieliuqu", page_start = 1, page_end = 1)
