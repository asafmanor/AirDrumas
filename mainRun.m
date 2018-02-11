clear; close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
global VERB
VERB = 'low';

% record variables
record.recordStickLoc = false;
record.recordFrames   = false;

runMode = 'online';
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

if strcmp(runMode, 'online')
    if ~exist('camR','var')
        camR = webcam(3);
    end
    if ~exist('camL', 'var')
        camL = webcam(2);
    end
    %ADInitializeRecordingSession(camR, camL, params)
    % init state for drum machine
    frames{1} = snapshot(camR);
    frames{2} = snapshot(camL); % #2 is left camera!
    lastLoc = ADInitState2(frames, params);
    if record.recordStickLoc
        record.stickLoc{1} = lastLoc;
    end
    
    gcf
    set(gcf, 'KeyPressFcn', @myKeyPressFcn)
    preview(camR);
    input('Ready when you are! Press any key to start playing ');
    historyR = []; historyL = [];
    t = 1;
    tic
    while ~KEY_IS_PRESSED
        t = t+1;
        drawnow
        frames{1} = snapshot(camR);
        frames{2} = snapshot(camL); % #2 is left camera!
        stickLoc = ADLocationPerTimestep(frames, params);
        if record.recordStickLoc
            record.stickLoc{t} = stickLoc;
        end
        if record.recordFrames
            record.frames{t} = frames;
        end
        [drumSound, lastLoc] = ADDecision3(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
    end
    record.totalTime = toc;
    record.totalFrames = t;
    close all;
    if record.recordStickLoc || record.recordFrames
        clk = string(clock);
        str = sprintf('rec_%s_%s', clk(4), clk(5));
        save(str, 'record', 'params');
    end
elseif strcmp(runMode, 'offline')
    load(fileToLoad)
    lastLoc = recordStickLoc{1};
    rate = totalTime / totalFrames;
    figure;
    for t = 2:totalFrames
        if exist('recordFrame', 'var')
            imshow(recordFrames{t}{1}); % show right camera
        end
        stickLoc = recordStickLoc{t};
        [drumSound, lastLoc] = ADDecision3(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        pause(rate);
    end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end