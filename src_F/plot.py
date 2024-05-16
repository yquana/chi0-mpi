import matplotlib.pyplot as plt
import numpy as np


x = [0e0]
kpt = [[0e0, 0e0, 0e0]]
ene = [[] for i in range(52)]

with open('out2', 'r') as f:
    for line in f:
      line = line.split()
      kpt.append(np.array([float(line[0]), float(line[1]), float(line[2])]))
      dis = np.linalg.norm(kpt[-1] - kpt[-2])
      x.append(dis + x[-1])
      for i in range(52):
        ene[i].append(float(line[i+3]))
        
del(x[0])
 
fig = plt.figure()
ax  = fig.add_subplot(111)
for i in range(52):
  ax.plot(x, ene[i], color = 'r')
#for i in range(8):
#  ax.axvline(x=x[i*50])
ax.set_ylim(-2e0, 2e0)
plt.savefig('out.png', format='png', dpi=400)
