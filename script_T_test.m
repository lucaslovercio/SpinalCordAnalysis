%Cleaning matlab workspace
clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currentFolder = pwd;
inicFolder = currentFolder;
segmentarStudies = true;

close all; clc;

addpath('profileFeatures');
addpath('segmentation');

%Open TIFF file
[filename,PathName] = uigetfile({'*','All Image Files'},'Open CSV',inicFolder);
dirCSV= strcat(PathName,filename);

T = readtable(dirCSV);
column_names = T.Properties.VariableNames;
sample_1 = T(:,1);
sample_2 = T(:,2);


sample_1 = table2array(sample_1);
sample_2 = table2array(sample_2);


x_limit_lower = min([min(sample_1),min(sample_2)]);
x_limit_upper = max([max(sample_1),max(sample_2)]);

[h,p] = ttest2(sample_1,sample_2)

figure('Name','Histograms');
histogram(sample_1,15,'facealpha',.5,'edgecolor','none')
column_name = strrep(column_names{1},'_',' ');
title(column_name);
hold on
histogram(sample_2,15,'facealpha',.5,'edgecolor','none')
hold off;
xlabel(column_name);
ylabel('Frequency');
axis([x_limit_lower x_limit_upper 0 100]);

