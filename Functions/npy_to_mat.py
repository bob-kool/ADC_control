#!/usr/bin/python3

import sys
import numpy
import scipy.io

npy_path = sys.argv[1]
mat_path = sys.argv[2]

data = numpy.load(npy_path)
try:
    scipy.io.savemat(mat_path, data[()])
except AttributeError:
    scipy.io.savemat(mat_path, {"data": data[()]})
