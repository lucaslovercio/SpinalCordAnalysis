function [Xsnake,Ysnake] = functionSegmentInterface( xInic, yInic, imgGray, dibujar )
[hOrig,wOrig]=size(imgGray);
%Pongo negro del lado derecho, luego lo saco
zerosToAdd = 1500;
imgGray = padarray(imgGray,[0 zerosToAdd],'symmetric','pre');
imgGray = padarray(imgGray,[0 zerosToAdd],'symmetric','post');

[h,w]=size(imgGray);
%Completar curva inicial
snakeY = ones(1,w)*yInic(1);
snakeY(floor(length(snakeY)/2):end) = yInic(end);
for i=2:length(xInic)
    x1 = zerosToAdd+xInic(i-1);
    x2 = zerosToAdd+xInic(i);
    xs = linspace(x1,x2,10000);
    y1 = yInic(i-1);
    y2 = yInic(i);
    ys = linspace(y1,y2,10000);
    for j=1:length(xs)%Generar la snake
        posx=floor(xs(j));
        if posx<1
            posx=1;
        end
        snakeY(posx)=ys(j);
    end
end

%Suavizar imagen
kernelGauss = fspecial('gaussian',[7 7], 3); imgFiltered = conv2(imgGray,kernelGauss,'same');

[~, Derivada2] = imgradientxy(imgFiltered, 'CentralDifference'); Derivada2(1,:)=0; Derivada2(end,:)=0;

if dibujar
    figure();
    imshow((Derivada2 - min(Derivada2(:)))/(max(Derivada2(:)) - min(Derivada2(:))));
    title('Derivada2');hold on; plot(1:w,snakeY,'r'); hold off;
end

balloonForcesScore = Derivada2;
gradientForces = Derivada2; %basura, para pasarle algo, el coef esta en 0
tensionCoef = 1; %0.1
flexuralCoef = 0;
inflationCoef = 1;
gradientCoef = 0;
deltaT = 0.1;
maxIter = 1000;
nrosVertices = w;

snakeX = 1:nrosVertices;
if dibujar
    figure(); imshow(Derivada2>0);title('derivada2 th inic');
    hold on; plot(snakeX,snakeY,'g'); hold off;
end
[Xsnake,Ysnake] = functionSnakePolarBalloon(imgGray, balloonForcesScore, gradientForces, tensionCoef, flexuralCoef, inflationCoef,gradientCoef, deltaT, maxIter, nrosVertices, snakeX, snakeY);
if dibujar
    figure();
    imshow(Derivada2>0);title('derivada2 th snake');
    hold on; plot(Xsnake,Ysnake,'g');
    plot(1:w,snakeY,'r'); hold off;
    figure();
    imshow(imgGray);title('resultado snake');
    hold on; plot(Xsnake,Ysnake,'g');
    plot(1:w,snakeY,'r'); hold off;
end

%Me quedo con la parte original

Xsnake = Xsnake(1:end-2*zerosToAdd);
Ysnake = Ysnake(zerosToAdd+1:end-zerosToAdd);
%GsmoothAbs = GsmoothAbs(:,1:end-zerosToAdd);

end

