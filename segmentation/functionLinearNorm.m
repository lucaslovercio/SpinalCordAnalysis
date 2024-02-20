function slice_original_norm = functionLinearNorm(slice_original)

min_image = min(slice_original(:));
max_image = max(slice_original(:));

slice_original_norm = (double(slice_original - min_image) )./ double(max_image-min_image);
    
end

