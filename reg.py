#!/usr/bin/env python
import sys
for line in sys.stdin:
    line = line.strip()
    items = line.split(',')
    label = items[2]
    features = items[3].replace('"', '')
    print '%s | %s'%(label, features)
