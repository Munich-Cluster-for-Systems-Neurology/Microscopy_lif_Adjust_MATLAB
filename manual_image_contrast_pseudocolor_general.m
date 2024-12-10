function [store_adj_images,adj_names] = manual_image_contrast_pseudocolor_general(maxonly,names,image_indices_of_interest,min_max,colors,bitdepth)
store_adj_images = {};
adj_names = {};
for j = 1:length(image_indices_of_interest)
    im_to_adjust = pseudocolor_adjust(maxonly(image_indices_of_interest(j),:),min_max,colors,bitdepth);
    figure;montage(im_to_adjust)
    title(names(image_indices_of_interest(j)))
    store_adj_images(j,:) = im_to_adjust;
    adj_names{j} = names(image_indices_of_interest(j));
end


function new_images = pseudocolor_adjust(test_im,min_max,colors,bitdepth)
% making colormaps
% Initialize the colormap matrix
black_to_magenta_colormap = zeros(bitdepth, 3);
black_to_cyan_colormap = zeros(bitdepth, 3);
black_to_blue_colormap = zeros(bitdepth, 3);
black_to_white_colormap = zeros(bitdepth, 3);
black_to_yellow_colormap = zeros(bitdepth, 3);


%fill colormaps
black_to_magenta_colormap(:, 1) = linspace(0, 1, bitdepth); % Red
black_to_magenta_colormap(:, 2) = zeros(1, bitdepth); % Green
black_to_magenta_colormap(:, 3) = linspace(0, 1, bitdepth); % Blue

black_to_cyan_colormap(:, 1) = zeros(1, bitdepth); 
black_to_cyan_colormap(:, 2) = linspace(0, 1, bitdepth); 
black_to_cyan_colormap(:, 3) = linspace(0, 1, bitdepth); 

black_to_blue_colormap(:, 1) = linspace(0, 0, bitdepth); 
black_to_blue_colormap(:, 2) = linspace(0, 0, bitdepth); 
black_to_blue_colormap(:, 3) = linspace(0, 1, bitdepth);

black_to_white_colormap(:, 1) = linspace(0, 1, bitdepth); 
black_to_white_colormap(:, 2) = linspace(0, 1, bitdepth);
black_to_white_colormap(:, 3) = linspace(0, 1, bitdepth);

black_to_yellow_colormap(:, 1) = linspace(0, 1, bitdepth); 
black_to_yellow_colormap(:, 2) = linspace(0, 1, bitdepth);
black_to_yellow_colormap(:, 3) = zeros(1, bitdepth);

colormap_inds = {'magenta','cyan','blue','white','yellow'};
colormaps = {black_to_magenta_colormap,black_to_cyan_colormap,black_to_blue_colormap,black_to_white_colormap,black_to_yellow_colormap};

%adjust images based on supplied min max values
adjusted_pseudo_max = {};
for i = 1:cols(test_im)
    find_colormap = find(~cellfun(@isempty,strfind(colormap_inds,colors{i})));
    converted_max = min_max{i}(2)/bitdepth;
    converted_min = min_max{i}(1)/bitdepth;
    J = imadjust(test_im{:,i},[converted_min converted_max],[0 1]);
    adjusted_pseudo_max{i} = ind2rgb(J, colormaps{find_colormap});
end

%create a merged image and return all newly adjusted images
new_images = {};
merged_img = zeros(size(adjusted_pseudo_max{1}));
for i = 1:length(adjusted_pseudo_max) %change to channels?
    new_images{end+1} = adjusted_pseudo_max{i};
    merged_img = imadd(merged_img,adjusted_pseudo_max{i});
end
new_images{end+1} = merged_img;
end

end
