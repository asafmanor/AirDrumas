function [params] = ADLoadParams()
% loads all the default parameters that should be inserted by the user.
% this is the only part where the user should intervene and make changes.

% OUTPUTS:  params: parameters struct

params.numOfSticks = 1;
params.numOfDrums = 4;
params.kit = 0;
params.origFrameSize = [1280 720];

[params.drums{1}.Sound params.drums{1}.fs] = audioread('Samples/00.wav'); % snare
[params.drums{2}.Sound params.drums{2}.fs] = audioread('Samples/04.wav'); % hi-hat
[params.drums{3}.Sound params.drums{3}.fs] = audioread('Samples/05.wav'); % ride
[params.drums{4}.Sound params.drums{4}.fs] = audioread('Samples/Kick006.wav'); % bass-drum

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
params.xmargin = 20;
params.ymargin = 20;
params.zmargin = 5;
params.margin = 0;
params.drumR = 50; % drum radius for decision type #2

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