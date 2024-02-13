function z_projection = functionZProject(volume)

[h,w,n_slices] = size(volume);

%Double to avoid overflow
volume_double = double(volume) ./ 100.;
volume_double = sum(volume_double,3);
volume_double = volume_double./n_slices;
z_projection = uint16(volume_double .* 100.);

end

