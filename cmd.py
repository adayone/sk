#!/usr/bin/env python
#!coding=utf-8
import os
import sys
import datetime
import time
import sqlite3
import urllib2
import math
import random

def get(code, pos):
    prefix = 'http://table.finance.yahoo.com/table.csv?s=%s.%s'
    addr = prefix%(code, pos)
    print addr
    try:
        #rs = urllib2.urlopen(addr, timeout=1.0).read()
        rs = os.popen('curl %s --max-time 10 --connect-timeout 2 '%addr).read()
    except Exception, e:
        print "Unexpected error:", str(e)
        return ''
    if len(rs) < 10:
        return ''
    time.sleep(0.1)
    return rs.replace('\n', ';')

def split_num(col):
    return len(col.strip().split(','))

def vw(col):
    if not col:
        return ''
    items = col.strip().split(' ')
    return '%s | %s'%(items[0].split(':')[1], ' '.join(items[1:]))

def pair(x, y):
    if len(x) < 2 or len(y) < 2:
        return ''
    xf = eval('{%s}'%(x.strip().replace(' ', ',')))
    yf = eval('{%s}'%(y.strip().replace(' ', ',')))
    rsp = {}
    keys = set(xf) | set(yf)
    for k in keys:
        if k not in xf:
            xf[k] = 0
        if k not in yf:
            yf[k] = 0
        rsp[k] = round(xf[k] - yf[k], 3)
    rss =  str(rsp).strip('{}').replace(',', ' ')
    return rss 

def splitview(item):
    rs = []
    candy_list = item[-1].split(';')
    code = item[0]
    pos = item[1]
    name = item[2]
    time = item[3]
    for candy in candy_list[1:]:
        s = '%s,%s,%s,%s'%(item[0], item[1],item[2], candy)
        slist = s.split(',')
        if len(slist) != 10:
            continue
        rs += [(slist)]
    return rs

def load(cur, conn):
    cur.execute("select distinct code, name, pos, history from stock_ori ")
    while True:
        item = cur.fetchone()
        if not item:
            break
        rows = splitview(item)
        if len(rows) < 1:
            continue
        sqlcmd = 'insert or ignore into stock values (?,?,?,?,?,?,?,?,?,?)'
        conn.executemany(sqlcmd, rows)

if __name__=='__main__':
    conn = sqlite3.connect("mlstock.db")
    conn.create_function("get", 2, get)
    conn.create_function("split_num", 1, split_num)
    conn.create_function("vw", 1, vw)
    conn.create_function("pair", 2, pair)
    cur = conn.cursor()
    if len(sys.argv) < 2:
        sys.exit(-1)
    elif sys.argv[1] == 'load':
        load(cur, conn)
    elif sys.argv[1] == '-e':
        cmd = sys.argv[2]
        cur.execute(cmd)
        rs = cur.fetchall()
        for item in rs:
            print item
    elif sys.argv[1] == '-f':
        sqlfile = sys.argv[2]
        sqlcmd = open(sqlfile, 'r').read()
        cur.executescript(sqlcmd)
    conn.commit()
    conn.close()

