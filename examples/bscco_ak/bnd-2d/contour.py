import matplotlib
matplotlib.use('Agg')
import numpy as np
import matplotlib.pyplot as plt


kx = []
ky = []
kz = []
ene = []
akw = []

gam = 0.02
with open('bands.dat','r') as f:
    for line in f:
        line = line.split(',')
        kx.append(float(line[0]))
        ky.append(float(line[1]))
        kz.append(float(line[2]))
        ene.append(float(line[3]))
        akw.append(gam/(ene[-1]**2e0 + gam**2e0))

fig = plt.figure()
ax  = fig.add_subplot(111,aspect=1e0)
ax.scatter(kx, ky, c=akw)
plt.savefig('out.png',format='png',dpi=400)
