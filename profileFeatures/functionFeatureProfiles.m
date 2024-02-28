function [list_max,list_negative_first_gradient,...
    list_negative_first_gradient_pos_px,list_negative_first_gradient_pos_real,...
    list_length_profile_px, list_length_profile_real] =...
    functionFeatureProfiles(list_all_profiles, pixel_size)

n_profiles = length(list_all_profiles);

list_max = zeros(size(list_all_profiles));
list_negative_first_gradient = zeros(size(list_all_profiles));
list_negative_first_gradient_pos_px = zeros(size(list_all_profiles));
list_negative_first_gradient_pos_real = zeros(size(list_all_profiles));
list_length_profile_px  = zeros(size(list_all_profiles));
list_length_profile_real  = zeros(size(list_all_profiles));

for i=1:n_profiles
    
    profile = list_all_profiles{i};
    [featureVector,strFeatures,~, ~] =...
    functionFeatureVectorColGray(double(profile), pixel_size);
    %disp(strFeatures)

    list_max(i) = featureVector(3);
    list_negative_first_gradient(i) = featureVector(9);
    
    list_negative_first_gradient_pos_px(i) = featureVector(12);
    list_negative_first_gradient_pos_real(i) = featureVector(13);
    
    list_length_profile_px(i) = length(profile);
    list_length_profile_real(i) = length(profile)*pixel_size;

end

