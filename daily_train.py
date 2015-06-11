#!/usr/bin/env python
import sys
import datetime as dp
s  = open('./sql/train.sql', 'r').read()
today = dp.datetime.today()
weekday = (dp.datetime.weekday(today) + 2)%5
s = s.replace('${weekday}', str(weekday))
f = open('./sql/daily_train.sql', 'w')
f.write(s)
f.close()

