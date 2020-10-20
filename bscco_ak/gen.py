import numpy as np
import os
import subprocess

f = open('chi.in','r')
lns = f.read().split('\n')
del(lns[-1])
del(lns[-1])
print(lns[-1])

for i in np.arange(1.004,3.14,0.005):
    ind = int (i * 1000)
    os.mkdir('c-'+str(ind))
    os.chdir('c-'+str(ind))
    lns[-1] = "{0:18.10f} 0.00 0.00 \n".format(i)
    with open('chi.in','w') as f:
        for item in lns:
            f.write(item + '\n')
    subprocess.call('../../bin/chi0.x > out',shell = True)
    os.chdir('../')
