function [params] = ADLoadParams()
% loads all the default parameters that should be inserted by the user.
% this is the only part where the user should intervene and make changes.

% OUTPUTS:  params: parameters struct

params.numOfSticks = 2;
params.numOfDrums = 3;
params.kit = 0;
params.origFrameSize = [1280 720];
%params.displayAnaglyph = false; % for diaplaying the Anaglyph on initialization.

% pre-processing params
params.pp.resize.enable = true;
params.pp.resize.resizeFactor = 1/4;

% xy location params
params.xy.maskTh = [55 25]; % red, blue
params.xy.maskChannel = [2 3]; % A, B channels
params.xy.negativeChannel = [0 1];

params.xy.searchMethod = 'horizontalLine';
params.xy.dy = 10;
params.xy.cropSize = [50 50];

% drum kit params

if params.kit == 0
    [params.drums{1}.Sound, params.drums{1}.fs] = audioread('Samples/04.wav'); % hi-hat
    [params.drums{2}.Sound, params.drums{2}.fs] = audioread('Samples/00.wav'); % snare
    [params.drums{3}.Sound, params.drums{3}.fs] = audioread('Samples/01.wav'); % floor-drum
    [params.drums{4}.Sound, params.drums{4}.fs] = audioread('Samples/02.wav'); % tam-drum
    [params.drums{5}.Sound, params.drums{5}.fs] = audioread('Samples/05.wav'); % crash-drum
    params.drums{1}.name = 'hihat';
    params.drums{2}.name = 'snare';
    params.drums{3}.name = 'floor';
    params.drums{4}.name = 'tam';
    params.drums{4}.Sound = 0.5 * params.drums{4}.Sound; % the tam is a bit noisy...
    params.drums{5}.name = 'crash';

else
    [params.drums{1}.Sound, params.drums{1}.fs] = audioread('Samples/14.wav'); % hi-hat
    [params.drums{2}.Sound, params.drums{2}.fs] = audioread('Samples/10.wav'); % snare
    [params.drums{3}.Sound, params.drums{3}.fs] = audioread('Samples/11.wav'); % kick-drum
    [params.drums{4}.Sound, params.drums{4}.fs] = audioread('Samples/12.wav'); % tam-drum
    [params.drums{5}.Sound, params.drums{5}.fs] = audioread('Samples/15.wav'); % clap-drum
    
    params.drums{1}.name = 'hihat';
    params.drums{2}.name = 'snare';
    params.drums{3}.name = 'kick';
    params.drums{4}.name = 'tam';
    params.drums{5}.name = 'clap'; 
end


params.maxAngle = 180;
params.minAngle = 0;
params.playerPosition = [0 0];
for n = 1:params.numOfDrums
    params.drums{n}.shift = 0;
end

% for decision type #4
params.marginOpenLock = 0.7; % margin for openning the lock while raising the stick 
params.marginHit = 1; % margin for global threshold for lowering the stick
params.lockOfStick{1} = 0;
params.lockOfStick{2} = 0;
params.drumsYLine = 80;

% stereo vision params
try
    temp = load('stereoParams.mat');
    params.stereoParams = temp.stereoParams;
catch
    error('stereoParams.mat does not exist!');
end
end