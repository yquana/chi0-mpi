import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

f=open('vec.dat', 'r') 
for i in range(28):
    f.readline()
line = f.readline().split()
ln = list(map(float, line))
fig = plt.figure()
ax  = fig.add_subplot(111)
ax.scatter([i for i in range(len(ln))], ln)
plt.savefig('out.png', format='png')
