#!/usr/bin/env python
#coding=utf-8
import sqlite3

new_db = sqlite3.connect(':memory:') # create a memory database
new_db.execute('select * from sim_index')
print new_db.featchone()
new_db.commit()
new_db.close()
