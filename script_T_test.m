%Cleaning matlab workspace
clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------NO PARAMETERS-------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currentFolder = pwd;
inicFolder = currentFolder;
segmentarStudies = true;

close all; clc;

%Open TIFF file
[filename,PathName] = uigetfile({'*','All Files'},'Open CSV',inicFolder);
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

hFigHist = figure('Name','Histograms');
hhist1 = histogram(sample_1,15,'facealpha',.5,'edgecolor','none');
title_plot = strrep(filename,'_',' ');
title_plot = strrep(title_plot,'.csv','');
title(title_plot);
hold on
hhist2 = histogram(sample_2,15,'facealpha',.5,'edgecolor','none');
hold off;
xlabel(title_plot);
ylabel('Frequency');
axis([x_limit_lower x_limit_upper 0 100]);
legend([hhist1 hhist2],{strrep(column_names{1},'_',' '),strrep(column_names{2},'_',' ')})

saveas(hFigHist,strcat(PathName,filename,'_histograms.png'));