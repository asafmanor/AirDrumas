clear;
params = ADLoadParams();

params.numOfSticks = 2;
params.playerPosition = [137 -40];
params.drums{1}.shift = 5;
params.drums{2}.shift = 3.5;
params.drums{3}.shift = 2;
params.minAngle = 10;
params.maxAngle = 175;
params.numOfDrums = 3;
params.drumsYLine = 45;
cams(1) = webcam(3);
cams(2) = webcam(2);

recordStickLoc = true;
recordFrames = true;
recordTime = 20;

saveStr = mainRunFunc('Live', 'cams', cams, 'recordStickLoc', recordStickLoc,...
    'recordFrames', recordFrames, 'recordTime', recordTime, 'params', params);
%input('Press any key to see your recording!')
%mainRunFunc('PlayAll', 'loadStr', saveStr);
%close all;
%delete [saveStr, '.mat']