#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
import requests
import pymysql
import time
import sys
import re
import os
from parsel import Selector


class douyin:
    def __init__(self):
        self.header = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'Accept-Encoding': '',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Host': 'www.douyin.com',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
        }
        self.uids = {'75382141971':'LL', '9330557830':'WD', '101019751610':'HNN'}
        self.db = pymysql.connect("localhost","yaccai","go","daily" )
        self.home = os.environ['HOME']

    def __del__(self):
        self.db.close()

    def jiexi(self, lists):
        pat = {
        u"\ue60d": 0,
        u"\ue603": 0,
        u"\ue616": 0,
        u"\ue60e": 1,
        u"\ue618": 1,
        u"\ue602": 1,
        u"\ue605": 2,
        u"\ue610": 2,
        u"\ue617": 2,
        u"\ue611": 3,
        u"\ue604": 3,
        u"\ue61a": 3,
        u"\ue606": 4,
        u"\ue619": 4,
        u"\ue60c": 4,
        u"\ue60f": 5,
        u"\ue607": 5,
        u"\ue61b": 5,
        u"\ue61f": 6,
        u"\ue612": 6,
        u"\ue608": 6,
        u"\ue61c": 7,
        u"\ue60a": 7,
        u"\ue613": 7,
        u"\ue60b": 8,
        u"\ue61d": 8,
        u"\ue614": 8,
        u"\ue615": 9,
        u"\ue61e": 9,
        u"\ue609": 9,
        "w": "w",
        ".": "." }
        _li = list()
        for i in lists:
            if str(i).strip():
                i = i.replace(u'<i class="icon iconfont follow-num">', "").strip()
                i = i.replace(u'<i class="icon iconfont ">', "").strip()
                i = i.replace(u'<i class="icon iconfont tab-num">', "").strip()
                i = pat.get(i, i)
                _li.append(str(i))
        return "".join(_li)


    def fetch(self, url):
        try:
            html = requests.get(url, headers = self.header).text
        except Exception as e:
            print('error:')
            print(e)
            html = None
        return html


    def spider(self, uid):
        html = self.fetch("https://www.douyin.com/share/user/%s" % uid)
        xbody = Selector(text = html)
        stmp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        name = self.uids[uid]

        douyinID = xbody.xpath("//p[@class='shortid']").extract_first()
        douyinID = re.findall(r'>([\s\S]+?)<', douyinID)
        douyinID = self.jiexi(douyinID).replace(u"抖音ID：", '').strip()
        # print('ID  ', douyinID)

        douyinSID = uid

        nickname = xbody.xpath("//p[@class='nickname']/text()").extract_first()
        # print('昵称', nickname)

        works = xbody.xpath("//div[@class='user-tab active tab get-list']/span").extract_first()
        works = re.findall(r'>([\s\S]+?)<', works)
        works = int(self.jiexi(works).strip())
        # print('作品', works)

        like = xbody.xpath("//div[@class='like-tab tab get-list']/span").extract_first()
        like = re.findall(r'>([\s\S]+?)<', like)
        like = int(self.jiexi(like).strip())
        # print('喜欢', like)

        follow = xbody.xpath("//span[contains(@class,'focus block')]/span[@class='num']").extract_first()
        follow = re.findall(r'>([\s\S]+?)<', follow)
        follow = int(self.jiexi(follow))
        # print('关注', follow)

        fans = xbody.xpath("//span[contains(@class,'follower block')]/span[@class='num']").extract_first()
        fans = re.findall(r'>([\s\S]+?)<', fans)
        fans = int(self.jiexi(fans))
        # print('粉丝', fans)

        liked = xbody.xpath("//span[contains(@class,'liked-num block')]/span[@class='num']").extract_first()
        liked = re.findall(r'>([\s\S]+?)<', liked)
        liked = int(self.jiexi(liked))
        # print('获赞', liked)

        sql_search = "select stmp, name, works, `like`, follow, nickName from douyin where name = '%s' order by stmp DESC limit 1" % name
        cursor = self.db.cursor()
        cursor.execute(sql_search)
        predata = cursor.fetchone() # 前面的数据
        diff = ''
        flag = 0
        if predata is not None:
            if predata[2] != works:
                diff += ('%8s: %5d  ==>  %-5d\n' % ('works', predata[2], works))
                flag |= 0b0001
            if predata[3] != like:
                diff += ('%8s: %5d  ==>  %-5d\n' % ('like', predata[3], like))
                flag |= 0b0010
            if predata[4] != follow:
                diff += ('%8s: %5d  ==>  %-5d\n' % ('follow', predata[4], follow))
                flag |= 0b0100
            if predata[5] != nickname:
                diff += ('%8s: %s  ==>  %s\n' % ('nickname', predata[5], nickname))
                flag |= 0b1000
            
            if diff != '':
                fname = time.strftime(name + ".%m-%d_%H-%M.txt", time.localtime())
                fpath = os.path.join(self.home, 'Desktop', fname)
                # with open(fpath,'w') as f:
                #     f.write(diff)
                # os.system('say , do check ' + name)
        sql_insert = "insert into douyin values(DEFAULT, '%s', '%s', '%s', '%s', '%d', '%d', '%d', '%d', '%d', '%d', '%s')" % (stmp, name, douyinID, douyinSID, works, like, follow, fans, liked, flag, nickname)
        cursor.execute(sql_insert)
        self.db.commit()


    def start(self):
        for uid in self.uids:
            self.spider(uid)
        

if __name__ == '__main__':
    douyin().start()