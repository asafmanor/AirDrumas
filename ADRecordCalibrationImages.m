function ADRecordCalibrationImages(camL, camR, params)
% function description

global debug;
% function body
root = pwd;
formatOut = 'ddmmyy_HHMMSS';
dateString = datestr(now,formatOut)
folder = ['calibImages_',dateString]
pathL = [root,'/CalibData/',folder,'/Left']
pathR = [root,'/CalibData/',folder,'/Right']

disp('Start recording calibration images')
numOfimages = 15;
for counter = [1:numOfimages]
    filename = ['image_' num2str(counter) '.png'];
    disp(['Iteration no.' num2str(counter) '. press any key to continue...']);
    pause;
    
    left_im = snapshot(camL);
    right_im = snapshot(camR);
    imwrite(left_im, [pathL,filename]);    
    imwrite(right_im, [pathR,filename]);    

end
disp('Recording session ended')

% debug dump
if debug.enable
	t = debug.timestep;
	% debug.some_parameter = some_parameter;
end

end






