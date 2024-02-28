function functionPlotProfiles(list_all_profiles, filename, list_length_px, pixel_size)


%Put all vectors together
lengthStandard = floor(mean(list_length_px)*0.9);
%lengthStandard = 60;
totalProfiles = length(list_all_profiles);

x = (1:lengthStandard)*pixel_size;

axis_plots = [0 (lengthStandard*pixel_size)  0 4000];
step_sampling_profiles = 5;
%Plotting profiles

hFigProfiles = figure('Name','Profiles together');

%plot(x,list_all_profiles{step_sampling_profiles}(1:lengthStandard));
axis(axis_plots);
title("");
xlabel("Distance (physical)");
ylabel("Expression intensity");

n_profiles = 1;
%for j=step_sampling_profiles+1:step_sampling_profiles:totalProfiles
for j=1:step_sampling_profiles:totalProfiles
    if length(list_all_profiles{j})>=lengthStandard
        hold on;
        plot(x,list_all_profiles{j}(1:lengthStandard));
        hold off;
        n_profiles = n_profiles + 1;
    end
end
title(strcat(num2str(n_profiles)," expression profiles of ", num2str(totalProfiles)));

saveas(hFigProfiles,strcat(filename,'_profiles_expression.png'));

%-------------------------------------------------------

%Shaded std


matrix_profiles = [];

for j=1:totalProfiles
    profile = list_all_profiles{j};
    if length(profile)>=lengthStandard
        matrix_profiles = horzcat(matrix_profiles, profile(1:lengthStandard));
    end
end

avg_data = mean(matrix_profiles,2,'omitnan');
std_data = std(matrix_profiles,0,2,'omitnan');

dashed_up = avg_data+std_data;
shade_down = avg_data-std_data;



hFigSvgStd = figure('Name','Mean and std');
plot(x, avg_data, 'k');
xlabel("Distance (physical)");
ylabel("Expression intensity");
hold on;
plot(x, dashed_up, 'k--');
plot(x, shade_down, 'k--');
hold off;
axis(axis_plots);
title("Average profile and standard deviation");

saveas(hFigSvgStd,strcat(filename,'_avg_expression.png'));




end

