
%Apertura del archivo
clear all; close all; clc;
addpath('altmany-export_fig-2763b78');
currentFolder = pwd;

inicFolder = currentFolder;

segmentarStudies = true;

%File opening
clearvars -except currentFolder inicFolderFile contentConfigFile contentConfigFile inicFolder segmentarStudies;

close all; clc;
    
[filename,PathName] = uigetfile({'*','All Image Files'},'Open Image',inicFolder);
dirImg= strcat(PathName,filename);

[volume,fileInfo, numImgs] = functionReadTIFFMultipage(dirImg);

%volume_optical = volume(:,:,0:2:numImgs);
volume_optical = volume(:,:,2:2:numImgs);
volume_expression = volume(:,:,1:2:numImgs);

% figure('Name','Multipage tiff');
% v = volume(:,:,1);
% subplot(2,2,1); imshow(functionLinearNorm(v)); max(v(:))
% v = volume(:,:,2);
% subplot(2,2,2); imshow(functionLinearNorm(v)); max(v(:))
% v = volume(:,:,45);
% subplot(2,2,3); imshow(functionLinearNorm(v)); max(v(:))
% v = volume(:,:,46);
% subplot(2,2,4); imshow(functionLinearNorm(v)); max(v(:))

%Project optical image such as Image J
z_projection_optical = functionZProject(volume_optical);
% 
% figure('Name','optical volume');
% v = volume_optical(:,:,1);
% subplot(2,1,1); imshow(functionLinearNorm(v)); max(v(:))
% v = volume_optical(:,:,2);
% subplot(2,1,2); imshow(functionLinearNorm(v)); max(v(:))

figure('Name','Z projection volume');
imshow(functionLinearNorm(z_projection_optical)); 

z_projection_optical_filtered = medfilt2(z_projection_optical,[3 3],'symmetric');
figure('Name','Filtered'); imshow(functionLinearNorm(z_projection_optical_filtered));

%z_projection_optical_inverted = ones(size(z_projection_optical)) - functionLinearNorm(z_projection_optical);
z_projection_optical_inverted = ones(size(z_projection_optical_filtered)) - functionLinearNorm(z_projection_optical_filtered);
        

%Annotate points and segment layers
list_interfaces = {};
rehacer = true;
new_segmentation = true;
close all;
hFig1 = figure('Name','Segment Anterior'); imshow(functionLinearNorm(z_projection_optical));

title('Select point of the top edge using Left-click, from left to right, and Press Enter');
while new_segmentation
    while rehacer
        tic;
        [xAnteriorManual, yAnteriorManual] = getpts(hFig1);
        elapsedLIAnteriorPoints = toc;
        %To show or not processing
        draw_intermediate = true;

        %figure, imshow(functionLinearNorm(z_projection_optical));
        
        tic;
        [xAnterior,yAnterior,GsmoothAbs] = functionSegmentInterface( xAnteriorManual, yAnteriorManual,...
            functionLinearNorm(z_projection_optical_inverted), draw_intermediate );
        timeAutoSegmentationLIAnterior = toc;
        figure(hFig1);
        hold on;
        hPlotActual = plot(xAnterior,yAnterior,'r');
        hold off;
        scriptQuestionMessage;
        if rehacer
            delete(hPlotActual);
        end
    end
    rehacer = true;
    list_interfaces{end+1} = [xAnterior;yAnterior];
    scriptQuestionMessage_More_Segments;
end

%Medicion diametro arterial
figure(hFig1);
xy_last = list_interfaces{end};
yPosterior=xy_last(2,:);
xPosterior=xy_last(1,:);
scriptLayersThickness;

%TODO SHOW Pixel Classification / Segmentation (prediction_2d) with segmented interfaces above it

%TODO SHOW Original image (originalOCT) with  segmented interfaces above it

%TODO Savefig automatically
%the file name can be easily named as
%strcat(dirImg,'_segmentation.png')

    %%
%Thickness evaluation
n_interfaces = length(list_interfaces);
str_conSaltoDeLinea = '';

for i=1:(n_interfaces-1)
    %anterior
    xy_first = list_interfaces{i};
    yAnterior=xy_first(2,:);
    xAnterior=xy_first(1,:);

    %posterior
    xy_last = list_interfaces{i+1};
    yPosterior=xy_last(2,:);
    xPosterior=xy_last(1,:);

    [hRegion,wRegion] = size(originalOCT);

    interfacePolarAnterior = functionInterfaceToImg( [xAnterior',yAnterior'] , hRegion, wRegion);
    maskAnterior = functionLabelizarPixelPolar( interfacePolarAnterior );

    interfacePolarPosterior = functionInterfaceToImg( [xPosterior',yPosterior'] , hRegion, wRegion);
    maskPosterior = functionLabelizarPixelPolar( interfacePolarPosterior );
    paredMaskArtery = xor(maskAnterior,maskPosterior);

    if draw_intermediate
        figure, imshow(paredMaskArtery); title("mask layer");
    end
    validoArteria = round(xDiametroValido(1)):1:round(xDiametroValido(2));
    disp(num2str(validoArteria));
    [meanPx, stdPx, imtPxMedia1, imtPxStd1, medicionesIMTmm1, imtPxMedian1,...
    imtPxMedia2, imtPxStd2, medicionesIMTmm2, imtPxMedian2] =...
        functionThicknessCells2( xAnterior,yAnterior,xPosterior,...
        yPosterior,validoArteria,paredMaskArtery, 1 );


    strStatistics = {strcat('Region: ',num2str(i)),...
        strcat('Distance px Mean: ',num2str(meanPx)),...
        strcat('Distance px Std: ',num2str(stdPx)),...
        strcat('-------------','----'),...
        strcat('Distance px Mean 1: ',num2str(imtPxMedia1)),...
        strcat('Distance px Std 1: ',num2str(imtPxStd1)),...
        strcat('Distance px Median 1: ',num2str(imtPxMedian1))...
        strcat('Number of measurements 1: ',num2str(medicionesIMTmm1)),...
        strcat('-------------','----'),...
        strcat('Distance px Media 2: ',num2str(imtPxMedia2)),...
        strcat('Distance px Std 2: ',num2str(imtPxStd2)),...
        strcat('Distance px Median 2: ',num2str(imtPxMedian2))...
        strcat('Number of measurements 2: ',num2str(medicionesIMTmm2)),...
        strcat('-------------------------------------------'),...
        };

    conSaltoDeLinea = strjoin(strStatistics,'\n');
    str_conSaltoDeLinea = strcat(str_conSaltoDeLinea,conSaltoDeLinea);

end

fid=fopen(strcat(dirImg,'_stats.txt'),'w');
fprintf(fid, [str_conSaltoDeLinea]);
%fprintf(fid, '%f %f \n', [A B]');
fclose(fid);

%save variables of the workspace
save(strcat(dirImg,'_features.mat'),'originalOCT_1','originalOCT','prediction','prediction_2d',...
    'xAnteriorManual', 'yAnteriorManual','xPosteriorManual', 'yPosteriorManual',...
    'list_interfaces',...
    'nroFrameSelected','filename','isImage','xDiametroValido');

%Iterate in other images
choice = MFquestdlg([0.3 0.3],'Segment other image?', ...
    'Segment other image', ...
    'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
       segmentarStudies = true;
    case 'No'
        segmentarStudies = false;
end
delete(hMsg);

clear all; close all; clc;