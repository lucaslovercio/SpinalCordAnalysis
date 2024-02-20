function [imtPxMedia, imtPxMedian, imtPxStd, imtPxMin, imtPxMax, mediciones, imtMedia,...
    imtMedian, imtStd, imtMin, imtMax, medicionesIMTmm, list_profiles] =...
    functionGetExpressionInSegment( xLI,yLI,xMA,yMA,xValid,paredMask, mmpx, slice_expression )

list_profiles = {};

validsX = round(xValid(1)):1:round(xValid(2));

xLI = xLI(validsX);
yLI = yLI(validsX);
xMA = xMA(validsX);
yMA = yMA(validsX);

[h,w]=size(paredMask);

ptsADescartar = 15;

nLI = length(xLI);
iLI = zeros(1,length(xLI)-2*ptsADescartar);
iMACorrespondants = iLI;
imtsPx = iLI;

n = 11; %distancia para sacar linea recta
medicionesIMT = zeros(1,length(xLI)-2*ptsADescartar);
stepNormal = 0.1;
stepHigherPendiente = 0.001;
for i=ptsADescartar:nLI-ptsADescartar
    
    profile_expression = [];
    
    posActual = [xLI(i),yLI(i)];
    p1 = [xLI(i-n),yLI(i-n)];
    p2 = [xLI(i+n),yLI(i+n)];
    
    pendiente = (p2(2)-p1(2))/(p2(1)-p1(1));
    pendientePerpendicular = -1/pendiente;
    ordenada = posActual(2)-pendientePerpendicular*posActual(1);
    if pendientePerpendicular>50 || pendientePerpendicular<-50
        step = stepHigherPendiente;
    else
        step = stepNormal;
    end
    
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
        if posActual(2)>0 && posActual(1)>0 && posActual(2)<=h && posActual(1)<=w...
                && posActual(1)>=xValid(1) && posActual(1)<=xValid(2) %The ray only inside the yellow range
        
            enPared = paredMask(ceil(posActual(2)),ceil(posActual(1)));
            
            %if (ceil(posActualOld(2)) ~= ceil(posActual(2))) || (ceil(posActualOld(1)) ~= ceil(posActual(1)))
                expression_value = slice_expression(ceil(posActual(2)), ceil(posActual(1)));
                %disp(expression_value);
                profile_expression = vertcat(profile_expression,expression_value);
            %end
            
        else
            existError = true;
        end
        %hold on; plot([posActualOld(1) posActual(1)],[posActualOld(2) posActual(2)]); hold off;
    end
    if not(existError)
        distance = sqrt((posActualOld(1) - xLI(i))^2 + (posActualOld(2) - yLI(i))^2 );
        list_profiles{end+1} = profile_expression;
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

imtMedia = mean(medicionesIMTmm);
imtMedian = median(medicionesIMTmm);
imtStd = std(medicionesIMTmm);
imtMin = min(medicionesIMTmm);
imtMax = max(medicionesIMTmm);

end