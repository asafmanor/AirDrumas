clear;
params = ADLoadParams();

params.numOfSticks = 2;
params.playerPosition = [125 -40];
params.drums{1}.shift = 5;
params.drums{2}.shift = 3.5;
params.drums{3}.shift = 2;
params.minAngle = 25;
params.maxAngle = 140;
params.numOfDrums = 3;
params.drumsYLine = 45;
cams(1) = webcam(3);
cams(2) = webcam(2);

mainRunFunc('Live', 'cams', cams, 'params', params);
close all;