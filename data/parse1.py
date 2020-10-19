import numpy as np

dic  = {}
dic1 = {}
dic2 = {}

for i in range(14):
    dic[i * 4]     = i
    dic[i * 4 + 1] = i + 14
    dic[i * 4 + 2] = i + 28
    dic[i * 4 + 3] = i + 42

    dic1[ i ]      = i * 4
    dic1[ i + 14]  = i * 4 + 1
    dic1[ i + 28]  = i * 4 + 2
    dic1[ i + 42]  = i * 4 + 3


for i in range(56):
    for j in range(56):
        dic2[str([i, j])] = []

wan_x = []
wan_y = []
R     = []
hop   = []

with open('./out', 'r') as f:
    f.readline()
    for line in f:
        line = line.split()
        dic2[str([int(line[0]) - 1, int(line[1]) - 1])].append([float(line[2]), float(line[3]), 
               float(line[4]), float(line[5]), float(line[6])])

with open('converted','w') as f:
    for i in range(4):
        for j in range(14):
            for l in range(4):
                for m in range(14):
                    indx = 14 * i + j
                    indy = 14 * l + m

                    indxo = dic1[indx]
                    indyo = dic1[indy]
                    for item in dic2[str([indxo, indyo])]:
                        f.write("{0:5d} {1:5d} {2:18.10f} {3:18.10f} {4:18.10f} {5:18.10f} {6:18.10f}\n".format( indx + 1, indy + 1, 
                                item[0], item[1], item[2], item[3], item[4]))
