function interface_result = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered)

z_projection_optical_inverted = ones(size(z_projection_optical_filtered)) - functionLinearNorm(z_projection_optical_filtered);

hFig1 = figure('Name','Segment Anterior');
imshow(functionLinearNorm(z_projection_optical));

title('Select point of the top edge using Left-click, from left to right, and Press Enter');

rehacer = true;
while rehacer
    %tic;
    
    [xAnteriorManual, yAnteriorManual] = getpts(hFig1);
    %uiwait(hFig1)
    %elapsedLIAnteriorPoints = toc;
    %To show or not processing
    draw_intermediate = false;

    %figure, imshow(functionLinearNorm(z_projection_optical));

    tic;
    [xAnterior,yAnterior] = functionSegmentInterface( xAnteriorManual, yAnteriorManual,...
        functionLinearNorm(z_projection_optical_inverted), draw_intermediate );
    %timeAutoSegmentationLIAnterior = toc;
    figure(hFig1);
    hold on;
    hPlotActual = plot(xAnterior,yAnterior,'r');
    hold off;
    scriptQuestionMessage;
    if rehacer
        delete(hPlotActual);
    end
end

interface_result = [xAnterior',yAnterior'];


end

