Batched microscopy image contrast adjustment and pseudocoloring in Matlab

Project description:
This package contains a package of functions to 1) read Z-stack images from .lif files, make max-intensity 
projections with pseudocolors, and make a merged image thereof, 2) manually adjust the contrast for 
each channel and re-make a contrast-adjusted merge image, and 3) write the adjusted images to tifs.

How to install the project:
In addition to standard Matlab functions, this code utilizes two functions developed by the Open 
microcopy team: bfopen and BioformatsImage. These can be found at 
https://docs.openmicroscopy.org/bio-formats/5.8.2/users/matlab/index.html. Ensure that each of these 
functions is in the Matlab path. This code should run on any operating system capable of running 
Matlab, but has been formally tested on Windows 10. No special hardware is required. If Matlab is 
already installed, installing the package should take less than 5 min. The code has been tested on Matlab 
R2020b.

Running the code:
Creating initial maximum intensity projections
First run the lif_build_max_projections function which takes the following arguments:
*	lif_file = the .lif file you would like to analyze.
*	colors = a cell array of strings containing the names of pseudocolors you would like to use, in 
order of the fluorescence channels in your .lif file. Options need to be limited to ‘magenta’, 
‘cyan’, ‘blue’, ‘white’, and/or ‘yellow’. Ensure the number of strings in the cell array matches 
either the number of channels in the .lif or the length of channels_of_interest (described 
below).
*	bitdepth = a numerical value for the bitdepth of your images, i.e. 8-bit would correspond 256.
*	gaussfilt = a Boolean asking whether you would like to apply a gaussian filter to the image – 
putting 1 here would apply the filter and any other entry would mean do not apply.
*	channels_of_interest = a matrix holding the indices for the channels that you would like to 
analyze further. This can be used to exclude channels that you do not wish to look at. Can be left 
empty if you would like to look at all channels.
This function will return cell arrays:
*	names = holds the names of samples taken from the .lif image
*	store_images_pseudo = holds max-intensity pseudocolored images (colored in order according 
to colors argument) including a merged image
*	store_images_maxonly = holds max-intensity grayscale images for further analysis
The code will also display a montage of the pseudocolored images from store_images_pseudo.

Manually adjusting contrast for selected images
Next, run the function manual_image_contrast_pseudocolor_general to apply a contrast adjustment to 
the images. The code takes the following arguments:
*	maxonly = the store_images_maxonly cell array returned from lif_build_max_projections
*	names = the names cell array returned from lif_build_max_projections
*	image_indices_of_interest = a matrix containing the selected indices of the images that you 
would like to analyze, with indices coming from the names array.
*	min_max = pairs of minimum and maximum values for contrast adjustment in 1X2 matrices 
stored in a cell array. The number of min/max pair matrices should match the number of 
channels in the maxonly images and be in the same order.
*	colors = described above
*	bitdepth = described above

This code will adjust the contrast of the selected images in maxonly according the min/max values 
supplied in min_max and return pseudocolored images according to the colors supplied in the colors 
argument. Along with a merged image, these will be stored in store_adj_images. It will also take the 
selected names corresponding to these adjusted images and store these in adj_names. The code will 
additionally display a montage of these new images.

Writing the images with a scale bar
Finally, run stored_images_write_tifs to write tifs from your pseudocolored, adjusted images. This 
function takes the following arguments:
*	lif_file = described above
*	store_images = cell containing the images you would like to write, e.g. those from 
store_adj_images
*	all_names = cell containing the names corresponding to those names, e.g. from adj_names
*	im_of_interest = matrix with the indices of the images in store_images that you would write, 
with the final image in this matrix receiving the scale bar
*	scale_bar_size = the length in microns of the scale bar you would like to draw.
The function will then write these images as .tifs into the current directory.

An example of this type of analysis can be found in image_adjust_driver.m.

Acknowledgments:
We acknowledge Openmicroscopy for making the bfopen and BioformatsImage functions as part of the 
bio-formats project. This work was supported by the joint efforts of The Michael J. Fox Foundation for 
Parkinson’s Research (MJFF) and the Aligning Science Across Parkinson’s (ASAP) initiative. MJFF 
administers the grants ASAP-000282 and ASAP- 024268 on behalf of ASAP and itself.
