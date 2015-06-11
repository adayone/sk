#!/usr/bin/env python
import pandas as pd
from sklearn.metrics import pairwise_distances
from sklearn.preprocessing import scale
import sys
import sqlite3

num = int(sys.argv[1])
conn = sqlite3.connect("mlstock.db")
df = pd.read_sql_query('select code, rate_list from rate_index_clean', con=conn) 
rate = pd.DataFrame(list(df.rate_list.str.split(',')))
pairs = pairwise_distances(rate, metric="cosine")
name = df.code
s = pd.DataFrame(pairs, index=name, columns=name)
conn.execute('delete from sim')
conn.commit()
rs = []
for i in name:
    sim_rs = s.ix[i]
    sim_rs = sim_rs.order()
    # 0 is the largest sim score
    neighour = sim_rs[:num]
    for k in neighour.keys():
        score = round(neighour.get(k), 6)
        print i, k, score
        rs += [(i,k, score)]
conn.executemany('insert into sim values(?,?,?)', rs)
conn.commit()
conn.close()
