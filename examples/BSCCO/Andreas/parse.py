import numpy as np

rx = []
ry = []
rz = []
iwan = []
jwan = []
hop  = []

with open('HdftBi_2Sr_2CaCu_2O_8_vac_20bohr_2D_cut1mev.out_conv_Z3.mat.csv', 'r') as f:
    for line in f:
        line = line.strip('\n').split(',')
        rx.append(int(line[0]))
        ry.append(int(line[1]))
        rz.append(int(line[2]))
        iwan.append(int(line[3]))
        jwan.append(int(line[4]))
        hop.append(float(line[5]))

for i in range(len(rx)):
    print ("{0:5d} {1:5d} {2:18.10f} {3:18.10f} {4:18.10f} {5:18.10f} {6:18.10f}".format(iwan[i], jwan[i],  rx[i],  ry[i],  rz[i], hop[i], 0e0))
