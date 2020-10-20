import numpy as np
import os
import subprocess
import matplotlib.pyplot as plt


f = open('chi.in','r')
lns = f.read().split('\n')
del(lns[-1])
del(lns[-1])
print(lns[-1])

x = []
y = []

case0 = np.arange(0,1.0,0.005)
case1 = np.arange(1.0040,3.135,0.005)

case = [item for item in case0] + [item for item in case1]

for i in  np.arange(0,3.14,0.005):
   # np.arange(1.0040,3.135,0.0050):
    ind = int (round(i * 1000))
    #os.mkdir('c-'+str(ind))
    os.chdir('c-'+str(ind))
    #lns[-1] = "{0:18.10f} 0.00 0.00 \n".format(i)
    #with open('chi.in','w') as f:
    #    for item in lns:
    #        f.write(item + '\n')
    #subprocess.call('../../bin/chi0.x > out',shell = True)
    with open('chi-k','r') as f:
        line = f.readline().split()
        x.append(float(line[0]))
        line = f.readline().split()
        y.append(float(line[2]))
    os.chdir('../')


fig = plt.figure()
ax  = fig.add_subplot(111)
ax.plot(x,y,marker='o')
ax.set_ylim(0,12)
plt.savefig('chi.png',format='png',dpi=300)
