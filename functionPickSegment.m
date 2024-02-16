function [xInicDiameter,xFinDiameter] = functionPickSegment(z_projection_optical, interface_anterior, interface_posterior)

h1 = figure();
imshow(functionLinearNorm(z_projection_optical));
hold on; plot(interface_anterior(:,1),interface_anterior(:,2),'g');
plot(interface_posterior(:,1),interface_posterior(:,2),'r');  hold off;

rehacer = true;

yAnterior = interface_anterior(:,2);
yPosterior = interface_posterior(:,2);

while rehacer
    
    title('Select start and end of segment of interest');
    [xInicDiameter, yInicDiameter]= ginput(1);
    a = yAnterior(round(xInicDiameter));
    b = yPosterior(round(xInicDiameter));
    hold on;
    p1 = plot([xInicDiameter,xInicDiameter],[a,b],'y');
    hold off;
    
    [xFinDiameter, yFinDiameter]= ginput(1);
    a = yAnterior(round(xFinDiameter));
    b = yPosterior(round(xFinDiameter));
    hold on;
    p2 = plot([xFinDiameter,xFinDiameter],[a,b],'y');
    hold off;
    xDiametroValido = sort([xInicDiameter,xFinDiameter]);
    
    choice = MFquestdlg([0.3 0.3],'Is it ok?', ...
        'Segment of interest', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            rehacer = false;
        case 'No'
            rehacer = true;
            delete(p1);delete(p2);
    end
    
end

delete(h1);

end

