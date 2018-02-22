% clear ; close all;

% camL = webcam(2);
% camR = webcam(3);
numOfimages = 15;

% ADRecordCalibrationImages(camL, camR, numOfimages)
% pause;
% % use stereoCalibration app for extracting stereoParams object
% 
% input('Press any key to continue...');
save('stereoParams.mat','stereoParams')
% 
% % validate calibration
disp('Validate the rectification process')
preview(camR);
preview(camL);

stop = 1;
figure; 
while(stop)
    input('Press any key to aquire pair of images');
    frames{1} = snapshot(camR);
    frames{2} = snapshot(camL);
    [rect_frames{1}, rect_frames{2}] = rectifyStereoImages(frames{1}, frames{2}, stereoParams);
    subplot(1,2,1);imshow(stereoAnaglyph(rect_frames{1}, rect_frames{2}));title('Rectified images');
    subplot(1,2,2); imshowpair(rect_frames{1}, rect_frames{2},'diff');title('Diff of images');
    prompt = 'Do you want to stop (Y/N)?\n';
    ans = input(prompt,'s');
    if strcmp(ans,'Y');
        stop = 0;
    end
end

