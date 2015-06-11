#!/usr/bin/env python
#coding=utf-8
import memcache
import sys
import sqlite3
s = memcache.Client(["127.0.0.1:11211"])
conn = sqlite3.connect('mlstock.db')
cur = conn.cursor()
cur.execute('select distinct x, ylist from sim_index')
rs = cur.fetchall()
for item in rs:
    key = item[0].encode('utf-8')
    value = item[1].encode('utf-8')
    s.set(key, value)

cur.execute('select trim(code), trim(prob) from daily_pred')
rs = cur.fetchall()
for item in rs:
    key = ('p_' + item[0]).encode('utf-8')
    value = str(item[1]).encode('utf-8')
    s.set(key, value)
conn.commit()

cur.execute('select avg(prob) from daily_pred')
dapan = cur.fetchone()
auc = open('./model/auc', 'r').read().split()[1].strip()
print auc
s.set('-2', 'all prob: '+ str(round(dapan[0], 4)) + '\nrmse: '+ str(auc))
cur.execute('select code, rate_list from rate_index')
rate_list = cur.fetchall()
for item in rate_list:
    key = ('r_' + str(item[0])).encode('utf-8')
    value = str(item[1]).encode('utf-8')
    s.set(key, value)
conn.commit()

key = '-1'
rss = ''
if float(auc) >= 0.5:
    cur.execute('select trim(code), trim(prob) from daily_pred order by prob  desc limit 10')
    rs = cur.fetchall()
    for item in rs:
        rss += item[0] + ','
else:
    cur.execute('select trim(code), trim(prob) from daily_pred order by prob  asc limit 10')
    rs = cur.fetchall()
    for item in rs:
        rss += item[0] + ','
s.set(key, rss.rstrip(','))


