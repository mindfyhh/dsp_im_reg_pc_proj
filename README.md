# dsp_im_reg_pc_proj
Extra credit image registration project using phase correlation. Used in EECE 5666 in 4/2015

This code uses two methods to estimate the pixel shift between between objects in two separate images. Mainly tested with two image of a CT scan cross section of an orange. The orange was moved a known amount, and the resolution of the CT scanner was known to determine the calculated pixel shift, that should be apparent between images. The estimated pixel shifts of the two methods were compared to this calculated known to determine efficiency. 

Currently reads in two images from active MATLAB folder (enter name of files into imread, order doesn't matter)


//This is a summary of the process behind the code, the full detail can be found in the full report in the repository.

The code takes two separate one dimensional FFT's of each image. A hamming window was used to focus on shifts in the center of the image as the orange from the test images does not shift too closely to the edges of the picture. A normalized cross correlation was then performed on the respective axes of both of the images in the frequency domain. Two methods were used to estimate the pixel shift.

The first looks at the the inverse fourier transform of the correlation. This resulting signal should correspond to the shift of each frequency on each axis. The maxima of this signal correspond to the frequency which represents the object shift since the object was intentionally shifted which results in a significantly higher value than the natural ambient changes in the images. This value is however obtained in the image space, since the inverse fourier transform maps the correlations found in the frequency space back to the image space and so has a shift estimation resolution of one pixel. 

The second technique looks at the plot of the derivative of the normalized correlation to find a linear rate of change (the constant shift) this slope corresponds to the pixel shift but with a higher resolution at fractions of a pixel. The second technique was determined to reduce errors in shift estimation in some cases by 30 percent. 

