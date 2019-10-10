# import numpy library as np
import numpy as np
import pylab as plt
# numerical data file
filename="nBytes.txt"
filename_fb="nBytes_fb.txt"


data = np.loadtxt(filename)
data_fb = np.loadtxt(filename_fb)

plt.plot(data,'b-')
plt.plot(data_fb,'r--')
plt.savefig('foo.pdf')
