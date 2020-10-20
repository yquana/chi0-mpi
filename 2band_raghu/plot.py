import matplotlib.pyplot as plt

x = []
y = []

with open('chi-k','r') as f:
    for line in f:
        line = line.split()
        x.append(float(line[0]))
        y.append(float(line[5])+float(line[-2]))

fig = plt.figure()
ax  = fig.add_subplot(111)
ax.plot([i for i in range(len(x))],y)
ax.set_ylim(0,0.8)
plt.savefig('out.png',format='png',dpi=300)
