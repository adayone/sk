#!/usr/bin/env python
import sys
for line in sys.stdin:
    line = line.strip()
    if float(line) > 0.005:
        print 1
    elif float(line) < - 0.005:
        print -1
    else:
        print 0
