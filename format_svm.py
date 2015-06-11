#!/usr/bin/env python
import sys
for line in sys.stdin:
    line = line.strip()
    items = line.split('|')
    label = items[0]
    features = items[1]
    print '%s qid:1 %s'%(label, features)
