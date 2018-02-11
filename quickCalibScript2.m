clear; close all; clc;
path = 'calibPictures/';
right_cam = webcam(2);
left_cam = webcam(3);
preview(right_cam);
preview(left_cam);
%%
input('press any key when ready to start calibration');
for counter = 1:20
    filename = ['image_' num2str(counter) '.png'];
    disp(['Iteration no.' num2str(counter)]);
    pause(2);
    
    left_im = snapshot(left_cam);
    right_im = snapshot(right_cam);
    imwrite(left_im, [path 'Left/' filename]);    
    imwrite(right_im, [path 'Right/' filename]);    

end
disp('acquisition ended');