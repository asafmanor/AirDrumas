clear ; close all;
global debug;
debug.enable = false;

camL = 1;
camR = 2;
numOfimages = 15;

ADRecordCalibrationImages(camL, camR, numOfimages)

% use stereoCalibration app for extracting stereoParams object

input('Press any key to continue...');
save('stereoParams.mat')

% validate calibration
disp('Validate the rectification process')

stop = 1;
figure; 
while(stop)
    input('Press any key to aquire pair of images');
    frames{2} = snapshot(camL);
    frames{1} = snapshot(camR);
    [rect_frames{2}, rect_frames{1}] = rectifyStereoImages(frames{2}, frames{1}, params.stereoParams);
    imshow(stereoAnaglyph(rect_frames{1}, rect_frames{2}));title('Rectified images');
    prompt = 'Do you want to record another pair (Y/N)?\n';
    ans = input(prompt,'s');
    if strcmp(ans,'Y');
        stop = 0;
    end
end

