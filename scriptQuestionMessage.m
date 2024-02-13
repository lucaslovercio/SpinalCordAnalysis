choice = MFquestdlg([0.3 0.3],'Segmentation satisfactory?', ...
    'Validate segmentation', ...
    'Yes, Continue','No, redo','No, redo');
% Handle response
switch choice
    case 'Yes, Continue'
        rehacer = false;
    case 'No, redo'
        rehacer = true;
end
