function Gsmooth = functionSmoothedGradient( imgPolar, dy )

% Gsmooth Unal et al Eq. 8
%anchoVentana = 2*dx+1;
%ventana = double(ones(dy,1));

%g = horzcat(imgPolar,imgPolar,imgPolar);

%g = functionExpandBorders(g,dy);

%suma = conv(double(imgPolar),ventana,'same');
%suma = suma ./ dy;

%w = gausswin(dy, 2.5);
%w = w/sum(w);

windowSize = dy; 
w = (1/windowSize)*ones(1,windowSize);
a = 1;

suma = filter(w, a, imgPolar);
%suma=suma(dy+1:end-dy,dy+1:end-dy);
distXYtoCenterBox = max(2,floor((dy+1)/2));
distBetCentreBoxes = floor(2 * distXYtoCenterBox);

%Central pixel
GsmoothPost = circshift(suma,[-distXYtoCenterBox ,0]) - suma;
GsmoothPre = suma - circshift(suma,[distXYtoCenterBox ,0]);
Gsmooth = (GsmoothPost + GsmoothPre) ./2; %in the center
Gsmooth = Gsmooth ./distBetCentreBoxes; % 1 unit displacement

Gsmooth(1:distXYtoCenterBox)=0;Gsmooth(end-distXYtoCenterBox:end)=0;%Not count problems in edges

end

