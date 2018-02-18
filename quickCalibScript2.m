clear; close all; clc;

root = 'calibPictures/';
if ~exist(root,'dir')
    mkdir(root);
end
cd calibPictures/;
if ~exist('Left', 'dir')
    mkdir Left;
end
if ~exist('Right', 'dir')
    mkdir Right;
end
cd ../

right_cam = webcam(2);
left_cam = webcam(3);
preview(right_cam);
preview(left_cam);

input('press any key when ready to start calibration');
for counter = 1:20
    filename = ['image_' num2str(counter) '.png'];
    disp(['Iteration no.' num2str(counter)]);
    pause(3);
    
    left_im = snapshot(left_cam);
    right_im = snapshot(right_cam);
    imwrite(left_im, [root 'Left/' filename]);    
    imwrite(right_im, [root 'Right/' filename]);    

end
disp('acquisition ended');