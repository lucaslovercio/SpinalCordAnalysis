function [meanPx, stdPx, imtPxMedia1, imtPxStd1, medicionesIMTmm1, imtPxMedian1,...
    imtPxMedia2, imtPxStd2, medicionesIMTmm2, imtPxMedian2, meanIMTReal, stdIMTReal] =...
    functionThickness( xLI,yLI,xMA,yMA, validoArteria, paredMask, mmpx )

[hRegion, wRegion] = size(paredMask);

[imtPxMedia1, imtPxMedian1, imtPxStd1, ~, ~, medicionesIMTmm1, imtMediaReal1,...
    imtMedianReal1, imtStdReal1, imtMinReal1, imtMaxReal1, ~] =...
    functionThickness2( xLI(validoArteria),yLI(validoArteria),xMA(validoArteria),yMA(validoArteria),paredMask, mmpx );

%Inversion para calcular desde la otra interfaz

paredMaskArtery2 = flipud(paredMask);
yPosterior2 = (yMA - ones(size(yMA)) * hRegion) .* (-1) + ones(size(yMA));
yAnterior2 = (yLI - ones(size(yLI)) * hRegion) .* (-1) + ones(size(yLI));

[imtPxMedia2, imtPxMedian2, imtPxStd2, ~, ~, medicionesIMTmm2, imtMediaReal2,...
    imtMedianReal2, imtStdReal2, imtMinReal2, imtMaxReal2, ~] =...
    functionThickness2(xLI(validoArteria),yPosterior2(validoArteria),xLI(validoArteria),yAnterior2(validoArteria),paredMaskArtery2, mmpx );

valuesIMTReal = [imtMediaReal1 imtMediaReal2];
meanIMTReal = mean(valuesIMTReal);
stdIMTReal = std(valuesIMTReal);

valuesPx = [imtPxMedia1 imtPxMedia2];
meanPx = mean(valuesPx);
stdPx = std(valuesPx);

end

