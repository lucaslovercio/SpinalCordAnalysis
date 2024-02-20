function [volume,fileInfo, numImgs] = functionReadTIFFMultipage(dirImage)

fileInfo = imfinfo(dirImage);
numImgs = size(fileInfo,1);
volume = uint16(zeros(fileInfo(1).Height,fileInfo(1).Width,numImgs));

for i=1:numImgs%For each tile
   slice = imread(dirImage,i, 'Info', fileInfo);
   %class(slice)
   volume(:,:,i) = uint16(slice);
end

end