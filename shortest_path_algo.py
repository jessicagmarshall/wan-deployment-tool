#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#Jessica Marshall
#ECE395 Senior Project
#shortest path algorithm 

import numpy as np
from skimage.graph import route_through_array

image = np.array([[1, 3], [10, 12]])
print('image array =',image)
print()

# Forbid diagonal steps
route_through_array(image, [0, 0], [1, 1], fully_connected=False)

# Now allow diagonal steps: the path goes directly from start to end
route_through_array(image, [0, 0], [1, 1])

# Cost is the sum of array values along the path (16 = 1 + 3 + 12)
route_through_array(image, [0, 0], [1, 1], fully_connected=False, geometric=False)

# Larger array where we display the path that is selected

image = np.arange((36)).reshape((6, 6))
print('image array =',image)
print()

# Find the path with lowest cost
indices, weight = route_through_array(image, (0, 0), (5, 5))
indices = np.array(indices).T

path = np.zeros_like(image)
path[indices[0], indices[1]] = 1

print(path)
