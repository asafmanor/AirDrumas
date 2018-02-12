close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
global VERB
VERB = 'low';

% record variables
record.recordStickLoc = true;
record.recordFrames   = false;

runMode = 'offline';
addpath('Samples');

if strcmp(runMode, 'online')
    params = ADLoadParams();
    % test asaf
    params.numOfSticks = 2;
    params.playerPosition = [110 0];
    params.drums{1}.shift = 59;
    params.drums{2}.shift = 59;
    params.drums{3}.shift = 61;
    params.minAngle = 25;
    params.maxAngle = 160;
    params.numOfDrums = 3;
    %params.drumGauges = gauges;
    % test - asaf
end

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
    if record.recordStickLoc || record.recordFrames
        clk = string(clock);
        str = sprintf('rec_%s_%s', clk(4), clk(5));
        save(str, 'record', 'params');
    end
elseif strcmp(runMode, 'offline')
    if ~exist('params', 'var')
        load('rec_0_10.mat')
    end
    params.drumGauges = gauges;
    % unpack record struct
    recordStickLoc = record.stickLoc;
    totalTime = record.totalTime;
    totalFrames = record.totalFrames;
    recordFrames = record.frames;
    
    lastLoc = recordStickLoc{1};
    rate = totalTime / totalFrames;
    
    for t = 2:totalFrames
        if exist('recordFrames', 'var')
            imshow(recordFrames{t}{1}); % show right camera
        end
        stickLoc = recordStickLoc{t};
        [drumSound, lastLoc] = ADDecision3(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        %pause(rate);
    end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end