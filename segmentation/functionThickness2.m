function [imtPxMedia, imtPxMedian, imtPxStd, imtPxMin, imtPxMax, mediciones, imtMediaReal,...
    imtMedianReal, imtStdReal, imtMinReal, imtMaxReal, medicionesIMTmm] =...
    functionThickness2( xLI,yLI,xMA,yMA,paredMask, mmpx )

flag_debug = false;
[h,w]=size(paredMask);

ptsADescartar = 50;

nLI = length(xLI);
iLI = zeros(1,length(xLI)-2*ptsADescartar);
iMACorrespondants = iLI;
imtsPx = iLI;

n = 11; %distancia para sacar linea recta
medicionesIMT = zeros(1,length(xLI)-2*ptsADescartar);
stepNormal = 0.1;

if flag_debug
    hFig_debug = figure('Name','Debug');
    imshow(paredMask);
end

for i=ptsADescartar:nLI-ptsADescartar
    posActual = [xLI(i),yLI(i)];
    p1 = [xLI(i-n),yLI(i-n)];
    p2 = [xLI(i+n),yLI(i+n)];
    
    pendiente = (p2(2)-p1(2))/(p2(1)-p1(1));
    pendientePerpendicular = -1/pendiente;
    ordenada = posActual(2)-pendientePerpendicular*posActual(1);
    
    step = stepNormal;
    
    %figure, imshow(paredMask);
    %hold on; plot(xLI,yLI,'r'); hold off;
    %Busqueda en la mascara
    enPared = paredMask(ceil(posActual(2)),ceil(posActual(1)));
    existError = false;
    posActualOld = posActual;
    while enPared && not(existError)
        posActualOld = posActual;
        if pendientePerpendicular<0
            posActual(1)=posActual(1)-step;
        else
            posActual(1)=posActual(1)+step;
        end
        posActual(2) = pendientePerpendicular*posActual(1)+ordenada;
        if posActual(2)>0 && posActual(1)>0 && posActual(2)<=h && posActual(1)<=w &&...
                xLI(1) <= posActual(1) && xLI(end) >= posActual(2)  %Between yellow range
            enPared = paredMask(ceil(posActual(2)),ceil(posActual(1)));
        else
            existError = true;
        end
        %hold on; plot([posActualOld(1) posActual(1)],[posActualOld(2) posActual(2)]); hold off;
    end
    if not(existError)
        distance = sqrt((posActualOld(1) - xLI(i))^2 + (posActualOld(2) - yLI(i))^2 );
        if flag_debug
                figure(hFig_debug);
                hold on; line([xLI(i), posActualOld(1)],[yLI(i) posActualOld(2)]);
                %hold on; line([yLI(i) posActualOld(2)],[xLI(i), posActualOld(1)]);
                hold off;
            end
        
    else
        distance = -1;
    end
    medicionesIMT(i-ptsADescartar+1)=distance;
    
end

medicionesIMT = medicionesIMT(medicionesIMT>0);

%Tengo que poner los parametros correctos
%scriptUSParameters;
medicionesIMTmm = medicionesIMT * mmpx;
    
imtPxMedia = mean(medicionesIMT);
imtPxMedian = median(medicionesIMT);
imtPxStd = std(medicionesIMT);
imtPxMin = min(medicionesIMT);
imtPxMax = max(medicionesIMT);
mediciones = length(medicionesIMT);

imtMediaReal = mean(medicionesIMTmm);
imtMedianReal = median(medicionesIMTmm);
imtStdReal = std(medicionesIMTmm);
imtMinReal = min(medicionesIMTmm);
imtMaxReal = max(medicionesIMTmm);

end