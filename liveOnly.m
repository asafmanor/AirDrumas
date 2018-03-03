clear;
params = ADLoadParams();

params.numOfSticks = 2;
params.playerPosition = [135 20];
params.drums{1}.shift = 5;
params.drums{2}.shift = 3.5;
params.drums{3}.shift = 2;
params.minAngle = 30;
params.maxAngle = 170;
params.numOfDrums = 3;
params.drumsYLine = 95;

recordOptions.recordStickLoc = false;
recordOptions.recordFrames = false;

cams(1) = webcam(3);
cams(2) = webcam(2);

mainRunFunc('Live', 'cams', cams, 'record', recordOptions, 'params', params);
close all;