import sys
for line in sys.stdin:
    line = float(line.strip())
    if line > 0:
        print 1
    else :
        print -1
