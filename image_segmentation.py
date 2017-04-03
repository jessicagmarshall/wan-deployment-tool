import matplotlib.pyplot as plt
from skimage.color import rgb2grey
import scipy
import scipy.misc
#from skimage import data

try:
    from skimage import filters
except ImportError:
    from skimage import filter as filters
from skimage import exposure

filename = '/19 Kelly Rd, Saugerties NY_zoom17'

camera = scipy.misc.imread('/Users/jessicamarshall/Desktop/SeniorProject/map_screenshots/' + filename + '.png')
camera = rgb2grey(camera)

val = filters.threshold_otsu(camera)

hist, bins_center = exposure.histogram(camera)

plt.figure(figsize=(9, 4))
plt.subplot(121)
plt.imshow(camera, cmap='gray', interpolation='nearest')
plt.axis('off')
plt.subplot(122)

segmented = camera < val
#0 - black, 1 - white

segmented = segmented.astype(int)
plt.imshow(segmented, cmap='gray', interpolation='nearest')
plt.axis('off')
#plt.subplot(133)
#plt.plot(bins_center, hist, lw=2)
#plt.axvline(val, color='k', ls='--')

#plt.tight_layout()
plt.show()

imagename = filename + '_greyscale'
scipy.misc.imsave("/Users/jessicamarshall/Desktop/SeniorProject/map_screenshots/" + imagename + ".png", camera)

imagename = filename + '_greysegmented'
scipy.misc.imsave("/Users/jessicamarshall/Desktop/SeniorProject/map_screenshots/" + imagename + ".png", segmented)