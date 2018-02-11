function [params] = ADLoadParams()
% loads all the default parameters that should be inserted by the user.
% this is the only part where the user should intervene and make changes.

% OUTPUTS:  params: parameters struct

params.numOfSticks = 1;
params.numOfDrums = 4;
params.kit = 0;
params.origFrameSize = [1280 720];

% pre-processing params
params.pp.gausssianFilter.enable = false;
params.pp.gausssianFilter.sigma = 0.5;
params.pp.medianFilter.enable = false;
params.pp.medianFilter.kernel = [3 3];
params.pp.resize.enable = true;
params.pp.resize.resizeFactor = 1/4;

% xy location params
params.xy.redMaskTh = 55;
params.xy.blueMaskTh = -20;

% drum kit params
% for decision type #1
params.xmargin = 20;
params.ymargin = 20;
params.zmargin = 5;
params.margin = 0;

% for decision type #2
[params.drums{1}.Sound, params.drums{1}.fs] = audioread('Samples/04.wav'); % hi-hat
[params.drums{2}.Sound, params.drums{2}.fs] = audioread('Samples/00.wav'); % snare
[params.drums{3}.Sound, params.drums{3}.fs] = audioread('Samples/Kick006.wav'); % bass-drum
[params.drums{4}.Sound, params.drums{4}.fs] = audioread('Samples/Kick006.wav'); % bass-drum
params.drumR = 50; % drum radius

% for decision type #3
params.maxAngle = 90;
params.minAngle = -90;
params.playerPosition = [0 0];
% decision type number 3 also uses shift

for n =1:6
    params.drums{n}.x = 0;
    params.drums{n}.y = 0;
    params.drums{n}.shift = 0;
end

% stereo vision params
try
    temp = load('stereoParams.mat');
    params.stereoParams = temp.stereoParams;
catch
    params.stereoParams = struct();
    warning('stereoParams.mat does not exist!');
end
end