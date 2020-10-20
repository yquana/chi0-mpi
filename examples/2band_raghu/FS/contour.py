import matplotlib
matplotlib.use('Agg')
import numpy as np
import matplotlib.pyplot as plt


kx = []
ky = []
kz = []
ene1 = []
ene2 = []
akw = []

gam = 0.02
ef = 1.45
with open('bands.dat','r') as f:
    for line in f:
        line = line.split(',')
        kx.append(float(line[0]))
        ky.append(float(line[1]))
        kz.append(float(line[2]))
        ene1.append(float(line[3]))
        ene2.append(float(line[4]))
        akw.append(gam/((ene1[-1]-ef)**2e0 + gam**2e0) + 
                   gam/((ene2[-1]-ef)**2e0 + gam**2e0))


kvx = []
kvy = []
kvz = []
ene = []
v = []
ak1 = []
ak2 = []

with open('vec.dat','r') as f:
    ind = 0
    for i, line in enumerate(f):
        line = line.split(',')
        if len(line) == 3:
            kvx.append(float(line[0]))
            kvy.append(float(line[1]))
            kvz.append(float(line[2]))
        if len(line) == 2 and i%4 == 1:
            ene.append(float(line[0]))
            line[1] = line[1].split()
            ak1.append(gam/((ene[-1]-ef)**2e0 + gam**2e0) *
                    (float(line[1][0])**2e0 + float(line[1][1])**2e0))
            ak2.append(gam/((ene[-1]-ef)**2e0 + gam**2e0) *
                    (float(line[1][2])**2e0 + float(line[1][3])**2e0))
        if len(line) == 2 and i%4 == 2:
            ene.append(float(line[0]))
            line[1] = line[1].split()
            ak1.append(ak1[-1] + gam/((ene[-1]-ef)**2e0 + gam**2e0) *
                    (float(line[1][0])**2e0 + float(line[1][1])**2e0))
            ak2.append(ak2[-1] + gam/((ene[-1]-ef)**2e0 + gam**2e0) *
                    (float(line[1][2])**2e0 + float(line[1][3])**2e0))


fig = plt.figure()
ax  = fig.add_subplot(111,aspect=1e0)
ax.scatter(kvx, kvy, c=[(1e0,1e0-item/max(ak1),1e0-item/max(ak1)) for item in ak1[::2]],s=0.4)
plt.savefig('FS1.png',format='png',dpi=400)

plt.close()

fig = plt.figure()
ax  = fig.add_subplot(111,aspect=1e0)
ax.scatter(kvx, kvy, c=[(1e0-item/max(ak1),1e0-item/max(ak1),1e0) for item in ak2[::2]],s=0.4)
plt.savefig('FS2.png',format='png',dpi=400)
