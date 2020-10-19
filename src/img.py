import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os
import subprocess


def read_dens(fname):
    ene = []
    dens = []
    with open(fname, 'r') as f:
        for i in range(56):
            line = f.readline()
            line = line.split()
            ene.append(float(line[0]))
            dens.append([])
        for i in range(56):
            for j in range(56):
                line = f.readline().split()
                dens[i].append(np.sqrt(float(line[0])**2e0 + float(line[1])**2e0))
    return ene, dens


if __name__ == '__main__':
    for item in os.listdir('./'):
        if 'dens' in item:
            ene, dens = read_dens(item)
            fig = plt.figure()
            ax  = fig.add_subplot(111)
            ax.imshow(dens)
            plt.savefig(item+'.png',format='png',dpi=400)
            plt.close()

