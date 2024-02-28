function [list_all_profiles] = functionGetAllProfiles(n_segments_inic,n_segments_step,n_segments_end,...
    volume_expression, interface_anterior, interface_posterior, meanPx, pixel_size)

%To obtain profiles per section
list_all_profiles = {};
for i=n_segments_inic:n_segments_step:n_segments_end
    %disp(strcat('---Segment:', num2str(i)));
    slice_expression = volume_expression(:,:,i);
    [xInicDiameter,xFinDiameter] = functionPickSegment(slice_expression, interface_anterior, interface_posterior);
    [paredMaskExpression, ~] = functionGetSegment(slice_expression, interface_posterior, interface_anterior, [xInicDiameter,xFinDiameter], pixel_size);
    
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, medicionesIMTmm, list_profiles] = functionGetExpressionInSegment( interface_posterior(:,1),...
        interface_posterior(:,2),interface_anterior(:,1),interface_anterior(:,2),[xInicDiameter,xFinDiameter],paredMaskExpression, 1, slice_expression, meanPx );
    %disp(num2str(medicionesIMTmm))
    %size(list_profiles)
    for j=1:length(list_profiles)
        list_all_profiles{end+1} = list_profiles{j};
    end
end


end

