#!/usr/local/bin/python3
# -*- coding:utf-8 -*- 

import os
import re
import sys
import pymysql
import datetime


def select(sql):
    db  = pymysql.connect("localhost","root","go","torrent" )
    cur = db.cursor()
    try:
        cur.execute(sql)
        db.commit()
        res = cur.fetchall()
    except:
        db.rollback()
        res = None
    cur.close()
    db.close()
    return res


def hourago(hago):
    dt   = datetime.datetime.now() - datetime.timedelta(hours = hago)
    return dt.strftime("%Y-%m-%d %H")


def ups_dago(dago = 0):
    sql = '''select date(DATE_SUB(now(), INTERVAL 1 day)), max(dayup) 
            from ttg 
            where date(logtime) = date(DATE_SUB(now(), INTERVAL %d day))''' % (dago)
    return select(sql)


def ups_hago(hago = 0):
    tft = '%Y-%m-%d %H'
    sql = '''select date_format(DATE_SUB(now(), INTERVAL 3 hour), '%s'), max(hourup) 
            from ttg 
            where date_format(logtime, '%s') = date_format(DATE_SUB(now(), INTERVAL %d hour), '%s')''' % (tft, tft, hago, tft)
    return select(sql)


def ups_hour(last = 6):
    tft = '%Y-%m-%d %H'
    sql = '''select  date_format(logtime, '%s') as Hour, max(hourup) as HourUp 
            from ttg 
            group by Hour
            order by Hour
            DESC
            limit %d''' % (tft, last + 1) # 0 小时以前 返回当前小时的结果
    return select(sql)


def ups_day(last = 6):
    tft = '%Y-%m-%d'
    sql = '''select  date_format(logtime, '%s') as Day, max(dayup) as DayUp from ttg 
            group by Day
            order by Day
            DESC
            limit %d''' % (tft, last + 1)
    return select(sql)


def ups_tab(last = 6):
    tft = '%Y-%m-%d %H'
    sql = '''select  date_format(logtime, '%s') as Hour, max(Hourup) as Up from ttg
            where to_days(now()) - to_days(logtime) <= %d
            group by Hour
            order by Hour
            DESC''' % (tft, last)
    dh  = dict()
    for it in select(sql):
        dh[it[0]] = it[1]

    dd  = dict()
    for it in ups_day (last):
        dd[it[0]] = it[1]

    sql = '''select  round((max(upsizeT) - min(upsizeT)) * 1024, 1) 
            from ttg
            where to_days(now()) - to_days(logtime) <= %d
    ''' % (last)
    res = select(sql)

    title = ''
    for i in range(0, 24):
        title = '%6d' % (i) if title == '' else '%s %6d' % (title, i)
    print(("%10s %7.2f %s" % ('GB', float(res[0][0]), title)))

    h = int(datetime.datetime.now().strftime('%H'))
    line = ''
    for i in range(0, h + last * 24 + 1):
        tk = hourago(i)
        up = float(dh.get(tk, 0))

        line = '%6.2f' % (up) if line == '' else '%6.2f %s' %(up, line)
        if tk[-2:] == '00':
            print ('%10s %7.2f %s' % (tk[:10], float(dd.get(tk[:10], '0')), line)) # 
            line = ''



if __name__ == '__main__':

    try:
        n = int(sys.argv[-1])
    except:
        n = 4
        
    if len(sys.argv) == 1:
        print("subcommand:")
        print("           size")
        print("                 <t: tab>   [number]")
        print("                 <d: day>   [number]")
        print("                 <h: hour>  [number]")
    elif sys.argv[1] == "size":
        if len(sys.argv) == 2:
            ups_tab(n)
        elif sys.argv[2] == 't':
            ups_tab(n)
        elif sys.argv[2] == 'd':
            for it in ups_day (last = n):
                print('%-13s  %6.2f GB' % (it[0], float(it[1])))
        elif sys.argv[2] == 'h':
            for it in ups_hour(last = n):
                print('%-13s  %6.2f GB' % (it[0], float(it[1])))
