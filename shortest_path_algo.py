#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#Jessica Marshall
#ECE395 Senior Project
#shortest path algorithm 

import numpy as np
from skimage.graph import route_through_array
from skimage.color import rgb2gray
import scipy
import scipy.misc
import matplotlib.pyplot as plt

#####TEST#####

image = np.array([[1, 3], [10, 12]])        #input image
#print('image array =',image)
#print()

# Forbid diagonal steps
route_through_array(image, [0, 0], [1, 1], fully_connected=False)

# Now allow diagonal steps: the path goes directly from start to end
route_through_array(image, [0, 0], [1, 1])

# Cost is the sum of array values along the path (16 = 1 + 3 + 12)
route_through_array(image, [0, 0], [1, 1], fully_connected=False, geometric=False)

#####TEST#####

# Larger array where we display the path that is selected

#image = np.arange((36)).reshape((6, 6))
image = scipy.misc.imread('/Users/jessicamarshall/Desktop/SeniorProject/map_screenshots/19 Kelly Rd, Saugerties NY_zoom17.png')

figure = plt.figure()
#axes = figure.add_subplot(1, 2, 1)
#imgplot = plt.imshow(image)


#image = image[:, :, 0]
image = rgb2gray(image)

axes = figure.add_subplot(1, 2, 1)
imgplot = plt.imshow(image, cmap = 'gray')



print('image array =', image)
print()

# Find the path with lowest cost (MAKE COST ARRAY USING CHANNEL MODEL)
indices, weight = route_through_array(image, (200, 0), (600, 100))
#indices, weight = route_through_array(image, (0, 0), (image.shape[0] - 1, image.shape[1] - 1))
indices = np.array(indices).T

path = np.zeros_like(image)
path[indices[0], indices[1]] = 1


axes = figure.add_subplot(1, 2, 2)
imgplot = plt.imshow(path, cmap = 'Greys')

