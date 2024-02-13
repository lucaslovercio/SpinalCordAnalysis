
%Apertura del archivo
clear all; close all; clc;

currentFolder = pwd;

inicFolder = currentFolder;

segmentarStudies = true;

%File opening
clearvars -except currentFolder inicFolderFile contentConfigFile contentConfigFile inicFolder segmentarStudies;

close all; clc;
    
[filename,PathName] = uigetfile({'*','All Image Files'},'Open Image',inicFolder);
dirImg= strcat(PathName,filename);

[volume,fileInfo, numImgs] = functionReadTIFFMultipage(dirImg);

volume_optical = volume(:,:,2:2:numImgs);
volume_expression = volume(:,:,1:2:numImgs);

%Project optical image such as Image J
z_projection_optical = functionZProject(volume_optical);

% figure('Name','Z projection volume');
% imshow(functionLinearNorm(z_projection_optical)); 

z_projection_optical_filtered = medfilt2(z_projection_optical,[3 3],'symmetric');
%figure('Name','Filtered'); imshow(functionLinearNorm(z_projection_optical_filtered));

interface_anterior = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered);
interface_posterior = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered);

close all;

[xInicDiameter,xFinDiameter] = functionPickSegment(z_projection_optical, interface_anterior, interface_posterior);


paredMaskArtery = functionGetSegment(z_projection_optical, interface_posterior, interface_anterior, [xInicDiameter,xFinDiameter]);

