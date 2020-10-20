rx = []
ry = []
rz = []
indx = []
indy = []
tre = []
tim = []


with open('2band.csv','r') as f:
    for line in f:
        line = line.split(',')
        rx.append(float(line[0]))
        ry.append(float(line[1]))
        rz.append(float(line[2]))
        indx.append(int(line[3]))
        indy.append(int(line[4]))
        tre.append(float(line[5]))


with open('tb','w') as f:
    f.write("1.00 0.00 0.00 \n")
    f.write("0.00 1.00 0.00 \n")
    f.write("0.00 0.00 1.00 \n")
    f.write("24    2\n")
    for i in range(len(rx)):
        f.write("{0:8d}{1:8d}{2:18.10f}{3:18.10f}{4:18.10f}{5:18.10f}{6:18.10f}\n".format(indx[i], indy[i], rx[i],ry[i],rz[i],tre[i],0e0))
