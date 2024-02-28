function [featureVector,strFeatures,featureVectorNorm, polarImageFiltered] =...
    functionFeatureVectorColGray( polarImage, pixel_size, varargin )
[heightPolar,widthPolar] = size(polarImage);
grayscaleInput = true;
th = 3000;

polarImageFiltered = polarImage;

mediaCol = mean(polarImageFiltered);%F1
maxCol = max(polarImageFiltered);%F3
minCol = min(polarImageFiltered);%F4
StdCol = std(polarImageFiltered);%F2

%[ ~, ~,~,maxGradienteAbs, normalizedCantPositivosCol] =...
%    functionPositiveClassProfile( polarImageFiltered, grayscaleInput, th );
%[MeanRelativeShadow ] = functionRelativeShadowCiompi(widthPolar,heightPolar);
%MeanRelativeShadow = mean(MeanRelativeShadow);
MeanShadow = functionShadowCiompi( polarImageFiltered, th, widthPolar, heightPolar );
MeanShadow = mean(MeanShadow);

[ firstMaxGradientCol, firstMinGradientCol,~, posMinGradient] =...
    functionGradientsCol( polarImageFiltered );
[medianUnderMaximo,RatioDong2013, stdShadow, candidatesCalcificationOtsu] =...
    functionFeaturesCalcificationGray( polarImageFiltered );

%Physical position of the Gradient
posMinGradientReal = posMinGradient * pixel_size;

featureVector = [mediaCol;StdCol;maxCol;minCol;...
    MeanShadow;...
    medianUnderMaximo;stdShadow;RatioDong2013;...
    firstMinGradientCol;...
    firstMaxGradientCol;...
    candidatesCalcificationOtsu;posMinGradient;posMinGradientReal];

strFeatures = {'mediaCol';'StdCol';'maxCol';'minCol';...
    'MeanShadow';...
    'medianUnderMaximo';'stdShadow';'RatioDong2013';...
    'firstMinGradientCol';...
    'firstMaxGradientCol';...
    'candidatesCalcificationOtsu';'posMinGradient';'posMinGradientReal'};

%disp(strFeatures);

[nFeatures, nSamples] = size(featureVector);
featureVectorNorm = zeros(nFeatures,nSamples);
for i=1:nFeatures
    featAux = featureVector(i,:);
    stdAux = std(featAux);
    if stdAux<0.0000001
        stdAux=0.0000001;
    end
    featAux = (featAux-mean(featAux))/stdAux;
    featureVectorNorm(i,:) = featAux;
end


