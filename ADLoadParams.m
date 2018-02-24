function [params] = ADLoadParams()
% loads all the default parameters that should be inserted by the user.
% this is the only part where the user should intervene and make changes.

% OUTPUTS:  params: parameters struct

params.numOfSticks = 1;
params.numOfDrums = 3;
params.kit = 0;
params.origFrameSize = [1280 720];
params.displayAnaglyph = false; % for diaplaying the Anaglyph on initialization.

% pre-processing params
params.pp.resize.enable = true;
params.pp.resize.resizeFactor = 1/4;

% xy location params
params.xy.redMaskTh = 55;
params.xy.blueMaskTh = -25;

% drum kit params
% for decision type #1,2 (not used)
params.xmargin = 20;
params.ymargin = 20;
params.zmargin = 5;
params.margin = 0;
params.drumR = 50;
for n = 1:params.numOfDrums
    params.drums{n}.x = 0;
    params.drums{n}.y = 0;
 end

% for decision type #2,3 (sound, fs, name, shift)
[params.drums{1}.Sound, params.drums{1}.fs] = audioread('Samples/04.wav'); % hi-hat
[params.drums{2}.Sound, params.drums{2}.fs] = audioread('Samples/00.wav'); % snare
[params.drums{3}.Sound, params.drums{3}.fs] = audioread('Samples/Kick006.wav'); % bass-drum
params.drums{1}.name = 'hihat';
params.drums{2}.name = 'snare';
params.drums{3}.name = 'floor';

params.maxAngle = 90;
params.minAngle = -90;
params.playerPosition = [0 0];
for n = 1:params.numOfDrums
    params.drums{n}.shift = 0;
end
% for decision type #4
params.marginOpenLock = 0.8; % margin for openning the lock while rising the stick 
params.marginHit = 2; % margin for global threshold for lowering the stick
params.lockOfStick{1} = 0;
params.lockOfStick{2} = 0;

% stereo vision params
try
    temp = load('stereoParams.mat');
    params.stereoParams = temp.stereoParams;
catch
    error('stereoParams.mat does not exist!');
end
end