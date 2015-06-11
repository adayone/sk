import sys
import math

rs = 0
index = 0
for line in sys.stdin:
    if len(line) < 3:
        continue
    items = line.split('\t')
    pred = float(items[1])
    real = float(items[2])
    if real > 0.5:
        real = 1
    elif real < -0.5:
        real = -1
    rs += (pred  - real) ** 2
    index += 1

print 'rmse',math.sqrt(rs/index)

