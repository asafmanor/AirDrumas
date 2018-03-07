close all; clc;
addpath('Samples');

params.displayAnaglyph = false;
params.xy.maskTh = [55 25]; % red, blue
params.xy.maskChannel = [2 3]; % A, B channels
params.xy.negativeChannel = [0 1];
params.xy.cropSize = [200 200];
params.pp.resize.resizeFactor = 1/2;

frames{1} = record.frames{2}{1};
frames{2} = record.frames{2}{2};
lastLoc = ADInitState2(frames, params);
input('Ready when you are! Press any key to start playing ');

t = 1;
%params.drumGauges = gauges;

% unpack record struct
recordStickLoc = record.stickLoc;
totalTime = record.totalTime;
totalFrames = record.totalFrames;
recordFrames = record.frames;

%lastLoc = recordStickLoc{1};
%rate = totalTime / totalFrames;

for t = 2:totalFrames
    if exist('recordFrames', 'var')
        imshow(recordFrames{t}{1}); % show right camera
    end
    frames{1} = recordFrames{t}{1};
    frames{2} = recordFrames{t}{2};
    stickLoc = ADLocationPerTimestep(frames, params, false, lastLoc);
    [drumSound, lastLoc] = ADDecision3(stickLoc, params, lastLoc);
    ADSound2(drumSound, params);
end