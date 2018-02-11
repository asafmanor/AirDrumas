close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
global VERB
VERB = 'low';

runMode = 'live';
addpath('Samples');
params = ADLoadParams();

% test asaf
params.numOfSticks = 2;
params.playerPosition = [210 0];
params.drums{1}.shift = 65;
params.drums{2}.shift = 69;
params.drums{3}.shift = 72.5;
params.minAngle = 10;
params.maxAngle = 170;
params.numOfDrums = 3;

params.drumGauges = gauges;

% test - asaf

if strcmp(runMode, 'live')
    if ~exist(var, camR)
        camR = webcam(3);
    end
    if ~exist(var, camL)
        camL = webcam(2);
    end
    %ADInitializeRecordingSession(camR, camL, params)
    % init state for drum machine
    frames{1} = snapshot(camR);
    frames{2} = snapshot(camL); % #2 is left camera!
    lastLoc = ADInitState2(frames, params);
    
    gcf
    set(gcf, 'KeyPressFcn', @myKeyPressFcn)
    preview(camR);
    input('Ready when you are! Press any key to start playing ');
    historyR = []; historyL = [];
    while ~KEY_IS_PRESSED
        drawnow
        frames{1} = snapshot(camR);
        frames{2} = snapshot(camL); % #2 is left camera!
        stickLoc = ADLocationPerTimestep(frames, params);
        [drumSound, lastLoc] = ADDecision3(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
    end
    close all;
end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end