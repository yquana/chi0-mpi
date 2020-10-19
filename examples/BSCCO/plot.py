import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


ene = []
with open('bands.dat', 'r') as f:
    for line in f:
        line = line.split()
        ene.append(float(line[3]))

fig = plt.figure()
ax  = fig.add_subplot(111)
ax.plot(ene)
plt.savefig('band.png', format='png', dpi=400)
