#import numpy as np

dic  = {}
dic1 = {}

for i in range(14):
    dic[i * 4]     = i
    dic[i * 4 + 1] = i + 14
    dic[i * 4 + 2] = i + 28
    dic[i * 4 + 3] = i + 42

    dic1[ i ]      = i * 4
    dic1[ i + 14]  = i * 4 + 1
    dic1[ i + 28]  = i * 4 + 2
    dic1[ i + 42]  = i * 4 + 3


rx = []
ry = []
rz = []

with open('./centers', 'r') as f:
    for line in f:
        line = line.split()
        rx.append(float(line[0]))
        ry.append(float(line[1]))
        rz.append(float(line[2]))

for i in range(56):
    print("{0:18.10f} {1:18.10f} {2:18.10f}\n".format(rx[dic1[i]], ry[dic1[i]], rz[dic1[i]]), end='')


'''
with open('./+hamdata', 'r') as f:
    lns = f.read().split("Tij, Hij:")
    lines = []
    del(lns[-1])
    header = lns[0]
    print(lns[0])
    for item in lns[1:]:
        if len(item) > 1:
            item = item.split('\n')
            del(item[0],item[-1])
            if len(item) > 1:
                lines.append(item)

    for i in range(len(lines)):
        for j in range(1, len(lines[i])):
            hop = list(map(float, lines[i][j].split()))
            ind = list(map(int, lines[i][0].split()))
            print("{0:8d}{1:8d}{2:18.10f}{3:18.10f}{4:18.10f}{5:18.10f}{6:18.10f}".format(ind[0], ind[1], hop[0],hop[1],
                  hop[2], hop[3], hop[4]))
'''
