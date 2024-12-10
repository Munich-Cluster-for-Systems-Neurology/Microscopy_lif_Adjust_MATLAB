%read in the data and make max intensity projections
lif_file ='Fig 6H - aggregation induction pre-treatment PFF leakage microscopy.lif';
colors = {'magenta','yellow','cyan','blue'}; %assign these colors to channels in this order
bitdepth = 256; %for an 8 bit image 
gaussfilt = 0; %forgo a gaussian filter; 1 would mean apply filter
channels_of_interest = [1 2 3 4]; %include all 4 channels in images
%could also leave empty if you want to look at all available channels; 
%could write [1 2 3] if you only want the first 3 channels

[names,store_images_pseudo,store_images_maxonly] = ...
    lif_build_max_projections(lif_file,colors,bitdepth,gaussfilt,channels_of_interest)



%adjust the intensity of the max intensity projections evenly across
%samples, re-pseudocolor, and make a new merged image
image_indices_of_interest = [1 2]; %images of interest, indices that in the names cell created above
min_max = {[0 256] [0 256] [10 256] [0 256]}; %min max pairs for contrast adjustment
%order applies to the channels above

[store_adj_images,adj_names] = manual_image_contrast_pseudocolor_general(store_images_maxonly,names,image_indices_of_interest,min_max,colors,bitdepth)


%write tifs of selected samples, using sample names as the file names,
%drawing a scale bar on the last image in the group of selected images
select_images_to_write = [1 2]; %indices now refer to those in store_images and store_names
%remember that the scale bar will be drawn on the last image
scale_bar_size = 20; %20 um scale bar

stored_images_write_tifs(lif_file,...
    store_adj_images,adj_names,select_images_to_write,20)