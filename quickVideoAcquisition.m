%% Image Acquistion
close all; clc; clear;
camList = webcamlist;
left_cam = webcam(3);
right_cam = webcam(2);
%%
preview(left_cam);
preview(right_cam);

%%
length = 120;
leftArray = zeros([720,1280,3,length]);
rightArray = zeros([720,1280,3,length]);
input('press any key when ready to shoot video');
for i=1:length
    pause(0.03);
    leftArray(:,:,:,i) = snapshot(left_cam);
    rightArray(:,:,:,i) = snapshot(right_cam);

end
disp('acquisition ended');