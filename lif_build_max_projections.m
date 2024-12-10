function [names,store_images_pseudo,store_images_maxonly] = lif_build_max_projections(lif_file,colors,bitdepth,gaussfilt,channels_of_interest)
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


%open the lif file
data = bfopen(lif_file)

num_ch = length(colors);
channels = 1:num_ch;
if nargin == 5
    channels = channels_of_interest;
end

%store the file names
names = {};
for i = 1:rows(data)
    instance = data{i,1};
    split_meta = strsplit(instance{1,2},';');
    names{end+1} = split_meta{2};
end



%store the images
store_images_pseudo = {};
for z = 1:rows(data)
    %read in image
    im = data{z,1};
    
    %get sample names
    split_meta = strsplit(im{1,2},';');
    splname = split_meta{2};
    splname2 = splname(1:end);
    
    %make max intensity projection
    maxs = {}; %stores max intensity projections
    zstack = [];
    for i=channels
        inds = i:num_ch:rows(im);
        zstack = zeros(size(im{1,1}));
        for j = 1:length(inds)
            zstack = cat(3,zstack,im{inds(j),1});
        end
        maxs{i} = max(zstack(:,:,2:end), [], 3);
    end
    
    %change colormap and add an optional gaussian filter
    pseudo_max = {}; %stores pseudocolored images
    maxonly = {}; %stores grayscale images
    for i=1:length(maxs)
        find_colormap = find(~cellfun(@isempty,strfind(colormap_inds,colors{i})));
        maxonly{i} = maxs{i};
        pseudo_max{i} = ind2rgb(maxonly{i}, colormaps{find_colormap});
        if gaussfilt == 1 %apply optional gaussian filter
            pseudo_max{i} = imgaussfilt(pseudo_max{i},1);
            maxonly{i} = imgaussfilt(maxonly{i},1);
        end
    end
    
    %merge the image and store 
    merged_img = zeros(size(pseudo_max{1}));
    new_images = {};
    new_maxonly = {};
    for i = 1:length(channels)
        new_images{end+1} = pseudo_max{channels(i)};
        new_maxonly{end+1} = maxonly{channels(i)};
        merged_img = imadd(merged_img,pseudo_max{channels(i)});
    end
    new_images{end+1} = merged_img;
  

    figure;montage(new_images);title(splname2)
    store_images_pseudo(z,:) = new_images;
    store_images_maxonly(z,:) = new_maxonly;

end
end