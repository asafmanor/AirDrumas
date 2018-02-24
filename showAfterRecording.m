params = ADLoadParams();
params.numOfSticks = 2;
params.playerPosition = [102 0];
params.drums{1}.shift = 8.5;
params.drums{2}.shift = 9;
params.drums{3}.shift = 12;
params.minAngle = 0;
params.maxAngle = 170;
params.numOfDrums = 3;

record.recordStickLoc = true;
record.recordFrames = true;
record.recordTime = 15;

saveStr = mainRunFunc('Live', record, [], params);
input('Press any key to see your recording!')
mainRunFunc('Test', [], saveStr, []);
%delete [saveStr, '.mat']