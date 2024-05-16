import matplotlib.pyplot as plt



with open('green0', 'r') as f:
    for i in range(50):
        x = []
        for j in range(56):
            x.append([])
            line = f.readline().split()
            for k in range(56):
                x[-1].append(float(line[2*k])**2e0 + float(line[2*k+1])**2e0)
        fig = plt.figure()
        ax  = fig.add_subplot(111)
        x = ax.imshow(x, vmax=2e0, vmin=0e0)
        plt.colorbar(x)
        plt.savefig('out' + str(i) + '.png', format='png', dpi=400)
        plt.close() 
        f.readline()
        
