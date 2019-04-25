#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
import requests
import re
import os
import sys
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

        douyin_id = xbody.xpath("//p[@class='shortid']").extract_first()
        douyin_id = re.findall(r'>([\s\S]+?)<', douyin_id)
        douyin_id = self.jiexi(douyin_id).replace(u"抖音ID：", '').strip()
        print('ID  ', douyin_id)

        nick_name = xbody.xpath("//p[@class='nickname']/text()").extract_first()
        print('昵称', nick_name)

        works = xbody.xpath("//div[@class='user-tab active tab get-list']/span").extract_first()
        works = re.findall(r'>([\s\S]+?)<', works)
        works = self.jiexi(works).strip()
        print('作品', works)

        like_num = xbody.xpath("//div[@class='like-tab tab get-list']/span").extract_first()
        like_num = re.findall(r'>([\s\S]+?)<', like_num)
        like_num = self.jiexi(like_num).strip()
        print('喜欢', like_num)

        guanzhu = xbody.xpath("//span[contains(@class,'focus block')]/span[@class='num']").extract_first()
        guanzhu = re.findall(r'>([\s\S]+?)<', guanzhu)
        guanzhu = self.jiexi(guanzhu)
        print('关注', guanzhu)

        # fans = xbody.xpath("//span[contains(@class,'follower block')]/span[@class='num']").extract_first()
        # fans = re.findall('>([\s\S]+?)<', fans)
        # fans = self.jiexi(fans)
        # print('粉丝', fans)

        # zan = xbody.xpath("//span[contains(@class,'liked-num block')]/span[@class='num']").extract_first()
        # zan = re.findall('>([\s\S]+?)<', zan)
        # zan = self.jiexi(zan)
        # print('获赞', zan)
        
        print('')



if __name__ == '__main__':
    douyin().spider(sys.argv[1])