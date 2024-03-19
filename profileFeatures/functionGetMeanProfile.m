function [mean_profile, std_profile, elem_profile, headersCSV] = functionGetMeanProfile(list_all_profiles)

total_profiles = length(list_all_profiles);
list_all_profiles_t = {};
for i=1:total_profiles
    temp_profile = list_all_profiles{i};
    temp_profile = temp_profile';
    list_all_profiles_t = [list_all_profiles_t, {temp_profile}];
end
maxLen = max(cellfun(@numel, list_all_profiles_t));
paddedMatrix = cellfun(@(x) padarray(x, [0 maxLen - numel(x)], NaN, 'post'), list_all_profiles_t, 'UniformOutput', false);
dataMatrix = cell2mat(paddedMatrix');

mean_profile = nanmean(dataMatrix);
std_profile = nanstd(dataMatrix);
elem_profile = sum(~isnan(dataMatrix));

headersCSV = {'Mean','Std','NumElem'};

end

