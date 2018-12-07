#!/usr/local/bin/python3
# -*- coding: utf-8 -*- 
exit()
import os
import re
import time
import requests
import common  as com
from   lxml           import html
print('torrent    @ ' + com.nowstr + ' ...')



ut_watch = os.path.join(os.environ['HOME'], 'Library/Application Support/uTorrent/watch')
qt_watch = os.path.join(os.environ['HOME'], 'Library/Application Support/qBittorrent/watch')
tr_watch = os.path.join(os.environ['HOME'], 'Library/Application Support/Transmission/watch')
vz_watch = os.path.join(os.environ['HOME'], 'Library/Application Support/Vuze/watch')

hour = int(time.strftime('%H'))

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


def get(url, cook):
    try:
        res = requests.get(url, cookies={'Cookie':cook}, timeout=10)
        res = res.content if res.ok else None
    except:
        print('get error  : %s' % url)
        res = None
    return res


def exsql(sql):
    import pymysql
    db = pymysql.connect("localhost", "root", "go", "torrent")
    cur = db.cursor()
    try:
        cur.execute(sql)
        db.commit()
        res = cur.fetchall()
    except:
        print('sql error  :', sql)
        db.rollback()
        res = None
    finally:
        cur.close()
        db.close()
    return res



def check_tg_Info(data):
    xtree = html.fromstring(data)
    usize = xtree.xpath('/html/body/table[2]/tr/td/table/tr/td[1]/span/font[4]/a')[0]
    usize = float(usize.text[:-3]) * (1.0 if usize.text[-2] == "T" else 0.001)
    res = exsql("insert into ttg (logtime, upsizeT) values ('%s', '%f')" % (com.nowstr, usize))
    res = exsql("select dayup, hourup from ttg order by logtime DESC limit 1")
    print('usize      : %.3f TB  %s GB  %s GB' % (usize, res[0][0], res[0][1]))

    dsize = xtree.xpath('/html/body/table[2]/tr/td/table/tr/td[1]/span/font[6]/a')[0]
    dsize = float(dsize.text[:-3]) * (1.0 if dsize.text[-2] == "T" else 0.001)
    print('dsize      : %.3f TB' % dsize)
    
    share = xtree.xpath('/html/body/table[2]/tr/td/table/tr/td[1]/span/font[2]')
    share = float(share[0].text)
    print('share      : %.3f' % share)

    jifen = xtree.xpath('/html/body/table[2]/tr/td/table/tr/td[1]/a[1]')
    jifen = float(jifen[0].text)
    print('jifen      : %.2f' % jifen)


    torrent_list = []
    free_count = 0
    serial_number = 0;
    for t in xtree.xpath('//*[@id="torrent_table"]/tr')[1:]:
        serial_number += 1
        try:
            name = t.xpath('./td[2]/div[1]/span/a/img[@class="report"]//@torrentname')[0] # 
            name = name.strip().replace(' ','.').replace('/','.').replace('#','').replace(':','')
            name = name.replace('`', '')

            free = t.xpath('./td[2]/div[1]/img[@alt="free"]/@alt') == ['free']
            hrun = t.xpath('./td[2]/div[1]/img[@title="Hit and Run"]/@title') == ['Hit and Run']
            free_count += 1 if free else 0

            date = t.xpath('./td[5]/nobr')[0].text
            stmp = t.xpath('./td[5]/nobr')[0].text_content().replace(date, date + ' ')
            tsec = time.mktime(time.strptime(stmp, "%Y-%m-%d %H:%M:%S"))

            snum, dnum = t.xpath('./td[9]')[0].text_content().replace('\n', '').split(' ')[0].split('/')
            snum = int(snum)
            dnum = int(dnum)

            href = t.xpath('./td[2]/div[2]/span/a[@class="dl_a"]/@href')[0]
            href = com.tgserver + href

            size = t.xpath('./td[7]/text()')
            size = float(size[0]) * (1.0 if size[-1] == 'GB' else 0.001)
        except Exception as e:
            print('             parse error')
            return
        if checkKeys(name, com.blocktg) or com.nowsec - tsec > 3600: # 跳过黑名单和太久种子
            continue

        if t.get('style') in ['', None]:
            if checkKeys(name, com.favortg) and com.nowsec - tsec < 7200:
                torrent_list.append((name, href))
                continue
            if name.find('-WiKi') > 0:
                torrent_list.append((name, href))
                continue
            if serial_number <= 3:
                torrent_list.append((name, href))
                continue

            if not free: #or hrun
                continue
            if size < 5:
                torrent_list.append((name, href))
                continue
            if size < 10 and dnum > 6  and com.nowsec - tsec < 1000: # int(size)
                torrent_list.append((name, href))
                continue
            if size < 15 and dnum > 10 and com.nowsec - tsec < 1500:
                torrent_list.append((name, href))
                continue
            if size < 60 and dnum > 25 and com.nowsec - tsec < 1800:
                torrent_list.append((name, href))
                continue


    if free_count > 40:
        print('too many free seeds')
        return


    for it in torrent_list:
        tname = it[0]
        thref = it[1]
        seed_file = os.path.join('/tmp', tname + '.torrent')
        if not os.path.exists(seed_file):
            print('fetchg     : %s' % tname)
            seed_data = get(thref, com.tgcook)
            if seed_data is None:
                continue
            with open(seed_file, 'wb') as f:
                f.write(seed_data)
                
        from torrentool.api import Torrent
        torrent_info = Torrent.from_file(seed_file)
        exist_size = 0
        total_size = torrent_info.total_size
        for it in torrent_info.files:
            if os.path.exists(os.path.join('/Volumes/Store/Torrent', it[0])):
                print('exists ', it[0])
                exist_size += it[1]
        if exist_size / total_size > 0.6:
            os.system('cp -f "%s" "%s"' % (seed_file, ut_watch))
        elif total_size <= 10 * 1000000000 :#and hour >= 8
            os.system('cp -f "%s" "%s"' % (seed_file, qt_watch))
        else:
            os.system('cp -f "%s" "%s"' % (seed_file, qt_watch))


def torinit():  

    if 0 != os.system('/usr/local/bin/fping -t 100 114.114.114.114 &>/dev/null'): 
        print("network    : error!\n\n")
        exit(-1)
    if not os.path.exists(com.mainDir):
        print('mainDir not found\n\n')
        exit(-2)




if __name__ == '__main__':
    start = time.time()
    torinit()

    page = get(com.tgTorURL, com.tgcook)
    if page is not None:
        check_tg_Info(page.decode('UTF-8'))

    print('time       : %.1fs\n\n' % (time.time() - com.nowsec))
