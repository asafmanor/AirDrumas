function ADRecordCalibrationImages(camL, camR, numOfimages)

root = pwd;
formatOut = 'ddmmyy_HHMMSS';
dateString = datestr(now,formatOut);
folder = ['calibImages_',dateString];
cd ./CalibData
mkdir(folder)
cd(folder)
mkdir Left
mkdir Right
cd ../..

pathL = [root,'CalibData/',folder,'/Left'];
pathR = [root,'CalibData/',folder,'/Right'];
disp(['Recording session ended files may be found at folder: ', folder]);

disp('Start recording calibration images')
for counter = [1:numOfimages]
    filename = ['image_' num2str(counter) '.png'];
    disp(['Iteration no.' num2str(counter) '. press any key to continue...']);
    pause;
    
    left_im = snapshot(camL);
    right_im = snapshot(camR);
    imwrite(left_im, [pathL,filename]);    
    imwrite(right_im, [pathR,filename]);    

end
disp(['Recording session ended files may be found at folder ', folder]);

end






