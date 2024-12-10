function stored_images_write_tifs(lif_file,store_images,all_names,im_of_interest,scale_bar_size)

%extract pixel size
bf_prop = BioformatsImage(lif_file);
px_size = bf_prop.pxSize(1);
scale_bar_px = scale_bar_size/px_size;


for i = 1:length(im_of_interest)
    for j = 1:cols(store_images)
        figure;imshow(store_images{im_of_interest(i),j},[])
        
        % draw a scale bar in the bottom right on the last image
        if i == length(im_of_interest) && j == cols(store_images)

            [~, yy, ~] = size(store_images{im_of_interest(i),j});
            rect_width = scale_bar_px;
            rect_height = 5;
            rect_x = 10;
            rect_y = yy - rect_height - 10;
            image_with_scalebar = insertShape(store_images{im_of_interest(i),j}, 'FilledRectangle', [rect_x, rect_y, rect_width, rect_height], 'Color', 'white');
            imshow(image_with_scalebar);
        else
            image_with_scalebar = store_images{im_of_interest(i),j};
        end
        
        title_str = [[all_names{im_of_interest(i)}{1},' C',num2str(j)]];
        imwrite(image_with_scalebar,[title_str '.tif'] );
        title(title_str)
    end
end
end
