%Cleaning matlab workspace
clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------------PARAMETERS-------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sampling of expression slices
n_segments_inic = 6;
n_segments_step = 5;
n_segments_end = 15;

% Pixel size
pixel_size = 0.6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currentFolder = pwd;
inicFolder = currentFolder;
segmentarStudies = true;

close all; clc;

addpath('profileFeatures');
addpath('segmentation');

%Open TIFF file
[filename,PathName] = uigetfile({'*','All Image Files'},'Open Image',inicFolder);
dirImg= strcat(PathName,filename);

[volume,fileInfo, numImgs] = functionReadTIFFMultipage(dirImg);

%Separete optical volume and expression volume
volume_optical = volume(:,:,2:2:numImgs);
volume_expression = volume(:,:,1:2:numImgs);

%Project optical image such as Image J
z_projection_optical = functionZProject(volume_optical);
z_projection_optical_filtered = medfilt2(z_projection_optical,[3 3],'symmetric');

%Bottom and upper interfaces
interface_anterior = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered);
interface_posterior = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered);

close all;

%To obtain the width of the spinal cord section
[xInicDiameter,xFinDiameter] = functionPickSegment(z_projection_optical, interface_anterior, interface_posterior);
[paredMaskExpression, strStatisticsGeometry, meanPx, meanReal] =...
    functionGetSegment(z_projection_optical, interface_posterior, interface_anterior,...
    [xInicDiameter,xFinDiameter], pixel_size);
%disp(strStatisticsGeometry);

[list_all_profiles] = functionGetAllProfiles(n_segments_inic,n_segments_step,n_segments_end,...
    volume_expression, interface_anterior, interface_posterior, meanPx, pixel_size);

%Feature extraction
[list_max,list_negative_first_gradient,...
    list_negative_first_gradient_pos, list_negative_first_gradient_pos_real,list_length_profile,list_length_real] =...
    functionFeatureProfiles(list_all_profiles, pixel_size);

%Build string
[strStatisticsExpression, matrixCSV, headersCSV] =...
    functionStatsProfiles(list_max,list_negative_first_gradient,...
    list_negative_first_gradient_pos,list_negative_first_gradient_pos_real,list_length_profile,list_length_real);

%Plot profiles
functionPlotProfiles(list_all_profiles, filename, list_length_profile, pixel_size);

%Save text file
fileID = fopen(strcat(filename,'_stats.txt'),'w');
fprintf(fileID,strStatisticsGeometry);
fprintf(fileID,strStatisticsExpression);
fclose(fileID);

%Save features to csv file
%fileID = fopen(strcat(filename,'_features.csv'),'w');
T = array2table(matrixCSV);
T.Properties.VariableNames(1:length(headersCSV)) = headersCSV;
writetable(T,strcat(filename,'_features.csv'))


