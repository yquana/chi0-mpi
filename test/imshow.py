import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


rho = []
kx = []
ky = []
kz = []

ene = []
vec_m = []

with open('vec.dat', 'r') as f:
    for line in f:
        line = line.split()
        if len(line) == 3:
            kx.append(float(line[0]))
            ky.append(float(line[1]))
            kz.append(float(line[2]))
            ene.append([])
            vec_m.append([])
        elif len(line) > 0:
            ene[-1].append(float(line[0]))
            for i in range(int((len(line)-1)/2e0)):
                vec_m[-1].append(float(line[2*i + 1])**2e0 + float(line[2*i + 2])**2e0)

vec_m = np.array(vec_m)

for i in range(len(ene)):
    vec = vec_m[i].reshape(56,56)
    fig = plt.figure()
    ax  = fig.add_subplot(111)
    ax.imshow(vec, vmin=0, vmax=0.5e0)
    plt.savefig('out'+str(i)+'.png', format='png', dpi=400)
    plt.close()
