%Apertura del archivo
clear all; close all; clc;

n_segments_inic = 6;
n_segments_step = 5;
n_segments_end = 25;

currentFolder = pwd;
inicFolder = currentFolder;
segmentarStudies = true;

close all; clc;

addpath('profileFeatures');
addpath('segmentation');

[filename,PathName] = uigetfile({'*','All Image Files'},'Open Image',inicFolder);
dirImg= strcat(PathName,filename);

[volume,fileInfo, numImgs] = functionReadTIFFMultipage(dirImg);

%Separete optical volume and expression volume
volume_optical = volume(:,:,2:2:numImgs);
volume_expression = volume(:,:,1:2:numImgs);

%Project optical image such as Image J
z_projection_optical = functionZProject(volume_optical);

% figure('Name','Z projection volume');
% imshow(functionLinearNorm(z_projection_optical)); 

z_projection_optical_filtered = medfilt2(z_projection_optical,[3 3],'symmetric');
%figure('Name','Filtered'); imshow(functionLinearNorm(z_projection_optical_filtered));

%Bottom and upper interfaces
interface_anterior = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered);
interface_posterior = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered);

close all;

%To obtain the width of the spinal cord section
[xInicDiameter,xFinDiameter] = functionPickSegment(z_projection_optical, interface_anterior, interface_posterior);
[paredMaskExpression, withLineBreak, meanPx] = functionGetSegment(z_projection_optical, interface_posterior, interface_anterior, [xInicDiameter,xFinDiameter]);
disp(withLineBreak);

%To obtain profiles per section
list_all_profiles = {};
for i=n_segments_inic:n_segments_step:n_segments_end
    disp(strcat('---Segment:', num2str(i)));
    slice_expression = volume_expression(:,:,i);
    [xInicDiameter,xFinDiameter] = functionPickSegment(slice_expression, interface_anterior, interface_posterior);
    [paredMaskExpression, ~] = functionGetSegment(z_projection_optical, interface_posterior, interface_anterior, [xInicDiameter,xFinDiameter]);
    
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, medicionesIMTmm, list_profiles] = functionGetExpressionInSegment( interface_posterior(:,1),...
        interface_posterior(:,2),interface_anterior(:,1),interface_anterior(:,2),[xInicDiameter,xFinDiameter],paredMaskExpression, 1, slice_expression, meanPx );
    disp(num2str(medicionesIMTmm))
    size(list_profiles)
    for j=1:length(list_profiles)
        list_all_profiles{end+1} = list_profiles{j};
    end
end

%Feature extraction
[list_max,list_negative_first_gradient,list_negative_first_gradient_pos, list_length] =...
    functionFeatureProfiles(list_all_profiles);

disp('---------------------------------------------------------');
disp('File');
disp(filename);

disp('median max');
disp(median(list_max));
disp('median neg gradient');
disp(median(list_negative_first_gradient));
disp('median pos neg gradient');
disp(median(list_negative_first_gradient_pos));
disp('median list_length');
disp(median(list_length));

disp('mean max');
disp(mean(list_max));
disp('mean neg gradient');
disp(mean(list_negative_first_gradient));
disp('mean pos neg gradient');
disp(mean(list_negative_first_gradient_pos));
disp('mean list_length');
disp(mean(list_length));

%%

%Plotting profiles

figure('Name','Profiles together');

plot(list_all_profiles{5});
xlim([0 80]);
ylim([0 4500]);

for j=5:5:length(list_all_profiles)
    hold on;
    plot(list_all_profiles{j});
    hold off;
end


%%
%Shaded std

%Put all vectors together
%lengthStandard = floor(mean(list_length)*0.8);
lengthStandard = 60;
totalProfiles = length(list_all_profiles);

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

x = 1:lengthStandard;

hFigSvgStd = figure('Name','Mean and std');
plot(x, avg_data, 'k');
hold on;
plot(x, dashed_up, 'k--');
plot(x, shade_down, 'k--');
hold off;
axis([0 lengthStandard 0 3500]);

saveas(hFigSvgStd,strcat(filename,'_avg_expression.png'));



