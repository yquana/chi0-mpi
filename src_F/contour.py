import matplotlib.pyplot as plt

kx = []
ky = []
kz = []
ene = [[] for i in range(56)]


with open('bands.dat','r') as f:
    for line in f:
        line = line.split(',')
        kx.append(float(line[0]))
        ky.append(float(line[1]))
        kz.append(float(line[2]))
        for j in range(56):
            ene[j].append(float(line[3 + j]))

apes = []
gam = 0.02

for j in range(len(ene[0])):
    intensity = 0e0
    for i in range(56):
        intensity += gam/(ene[i][j]**2e0 + gam**2e0)
    apes.append(intensity)


fig = plt.figure()
ax  = fig.add_subplot(111)
ax.scatter(kx,ky, c=apes, s=5.0, vmin=0e0)
plt.savefig('out.png', format='png', dpi=400)
