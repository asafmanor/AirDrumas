close all; clc; clear;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;

% record variables
record.recordStickLoc = true;
record.recordFrames   = true;

runMode = 'Test';
addpath('Samples');

if strcmp(runMode, 'Live')
    params = ADLoadParams();
    params.numOfSticks = 2;
    params.playerPosition = [102 0];
    params.drums{1}.shift = 8.5;
    params.drums{2}.shift = 9;
    params.drums{3}.shift = 12;
    params.minAngle = 0;
    params.maxAngle = 170;
    params.numOfDrums = 3;
    if ~(record.recordStickLoc || record.recordFrames)
        params.drumGauges = gauges;
    end
end

if strcmp(runMode, 'Live')
    if ~exist('camR','var')
        camR = webcam(2);
    end
    if ~exist('camL', 'var')
        camL = webcam(3);
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
    t = 1;
    tic
    while ~KEY_IS_PRESSED
        t = t+1;
        drawnow
        frames{1} = snapshot(camR);
        frames{2} = snapshot(camL); % #2 is left camera!
        stickLoc = ADLocationPerTimestep(frames, params, false, lastLoc);
        if record.recordStickLoc
            record.stickLoc{t} = stickLoc;
        end
        if record.recordFrames
            record_frames = cellfun(@(x) imresize(x, 1/2), frames, 'UniformOutput', false);
            record.frames{t} = record_frames;
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
elseif strcmp(runMode, 'Test')
    if ~exist('params', 'var')
        load('rec_10_52.mat')
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
    end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end