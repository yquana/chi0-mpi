from mayavi import mlab

a = []
b = []
c = []

with open('latt', 'r') as f:
    f.readline()
    line = f.readline()
    line = line.split()
    a = list(map(float, line))
    line = f.readline()
    line = line.split()
    b = list(map(float, line))
    line = f.readline()
    line = line.split()
    c = list(map(float, line))


mlab.plot3d([0e0, a[0]], [0e0, a[1]], [0e0, a[2]])
mlab.plot3d([0e0, b[0]], [0e0, b[1]], [0e0, b[2]])
mlab.plot3d([0e0, c[0]], [0e0, c[1]], [0e0, c[2]])
mlab.show()
