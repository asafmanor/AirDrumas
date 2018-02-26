function saveStr = mainRunFunc(runMode, cams, record, loadStr, params)
close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
global rectifiedRec

% record variables
saveStr = '';
addpath('Samples');

if strcmp(runMode, 'Live')
    if ~exist('params', 'var')
        error('in Live mode, you must give mainRunFunc the params struct');
    end
    camR = cams(1);
    camL = cams(2);
    % init state for drum machine
    frames{1} = snapshot(camR);
    frames{2} = snapshot(camL); % #2 is left camera!
    lastLoc = ADInitState2(frames, params, params.displayAnaglyph);
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
        stickLoc = ADLocationPerTimestep(frames, params);
        if record.recordStickLoc
            record.stickLoc{t} = stickLoc;
        end
        if record.recordFrames
            record.frames{t} = rectifiedRec;
        end
        [drumSound, lastLoc, params] = ADDecision4_5(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        if isfield(record, 'recordTime') && toc > record.recordTime
            break;
        end
    end
    record.totalTime = toc;
    record.totalFrames = t;
    if record.recordStickLoc || record.recordFrames
        clk = string(clock);
        str = sprintf('rec_%s_%s', clk(4), clk(5));
        save(str, 'record', 'params');
        saveStr = str;
    end
elseif strcmp(runMode, 'Test')
    load([loadStr,'.mat'], 'record');
    if isempty(params)
        load([loadStr,'.mat'], 'params');
    end
    %params.drumGauges = gauges;
    % unpack record struct
    recordStickLoc = record.stickLoc;
    totalTime = record.totalTime;
    totalFrames = record.totalFrames;
    recordFrames = record.frames;
    
    lastLoc = recordStickLoc{1};
    rate = totalTime / totalFrames;
    dispParams = CalcOfflineDispParams(params, recordFrames{2}{1});
    
    for t = 2:totalFrames
%                 if exist('recordFrames', 'var')
%                     imshow(recordFrames{t}); % show right camera
%                 end
        stickLoc = recordStickLoc{t};
        [drumSound, lastLoc, params] = ADDecision4_5(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        DisplayPerTimeStamp(stickLoc, recordFrames{t}{1}, dispParams);
    end
end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end