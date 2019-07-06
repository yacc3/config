#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
import os
import requests

pt_cook = 'bgPicName=Default; __utmz=248584774.1561468850.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); c_expiresintv=0; c_secure_uid=ODMzMzM%3D; c_secure_pass=75980e90b74ea6921ff40334a006275c; c_secure_ssl=eWVhaA%3D%3D; c_secure_login=bm9wZQ%3D%3D; __utmc=248584774; __utma=248584774.1117353316.1561468850.1562401481.1562409015.54; __utmt=1; __utmb=248584774.6.10.1562409015'
pt_index = 'https://pt.sjtu.edu.cn/index.php'

res = requests.get(pt_index, cookies={'Cookie':pt_cook})
res.encoding='utf-8'
fname = os.path.join(os.environ['HOME'],'Desktop'), 'PT有邀请'
if res.text[3635:].find('邀请') > 0 and not os.path.exists(fname):
    with open(fname,'w'):pass
