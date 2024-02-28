function interface_result = functionPickPointsAndSegmentInterface(z_projection_optical, z_projection_optical_filtered,...
    title_window)

z_projection_optical_inverted = ones(size(z_projection_optical_filtered)) - functionLinearNorm(z_projection_optical_filtered);

hFig1 = figure('Name','Segment interface');
imshow(functionLinearNorm(z_projection_optical));

title(title_window);

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

