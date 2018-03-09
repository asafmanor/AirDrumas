function saveStr = mainRunFunc(runMode, varargin)
close all; clc;
global rectifiedRec
global stats
stats.ffs = 0;
stats.nffs = 0;

p = inputParser;
p.StructExpand = false;
addParameter(p, 'cams', []);
addParameter(p, 'recordStickLoc', false);
addParameter(p, 'recordFrames', false);
addParameter(p, 'recordTime', inf);
addParameter(p, 'loadStr', []);
addParameter(p, 'params', []);
parse(p, varargin{:});

options = p.Results;
params = options.params;

% record variables
saveStr = '';
addpath('Samples');

if strcmp(runMode, 'Live')
    if ~exist('params', 'var')
        error('in Live mode, you must give mainRunFunc the params struct');
    end
    camR = options.cams(1);
    camL = options.cams(2);
    % init state for drum machine
    frames{1} = snapshot(camR);
    frames{2} = snapshot(camL); % #2 is left camera!
    %lastLoc = ADInitState2(frames, params);
    [lastLoc, kf] = ADInitState2(frames, params, false);
    if options.recordStickLoc
        record.stickLoc{1} = lastLoc;
    end
    
    preview(camR);
    disp(params);
    input('Ready when you are! Press any key to start playing ');
    close;
    t = 1;
    tic
    profile on;
    while true
        t = t+1;
        %drawnow
        frames{1} = snapshot(camR);
        frames{2} = snapshot(camL); % #2 is left camera!
        [stickLoc, kf] = ADLocationPerTimestep(frames, params, 'kalmanFilter', kf);
        if options.recordStickLoc
            record.stickLoc{t} = stickLoc;
        end
        if options.recordFrames
            % this global variable rectifiedRec should be updated
            % with the rectified frames from ADLocationPerTimestep
            record.frames{t} = rectifiedRec;
        end
        [drumSound, lastLoc, params] = ADDecision4_5(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        if toc > options.recordTime
            break;
        end
    end
    record.totalTime = toc;
    record.totalFrames = t;
    if options.recordStickLoc || options.recordFrames
        clk = string(clock);
        str = sprintf('rec_%s_%s', clk(4), clk(5));
        save(str, 'record', 'params');
        saveStr = str;
    end
elseif strcmp(runMode, 'PlayAll')
    load([options.loadStr,'.mat'], 'record');
    if isempty(params)
        load([options.loadStr,'.mat'], 'params');
    end
    % unpack record struct
    recordStickLoc = record.stickLoc;
    totalTime = record.totalTime;
    totalFrames = record.totalFrames;
    recordRectFrames = record.frames;
    
    lastLoc = recordStickLoc{1};
    rate = totalTime / totalFrames;
    disp(1./rate);
    dispParams = CalcOfflineDispParams(params, recordRectFrames{2}{1});
    
    for t = 2:totalFrames
%                 if exist('recordFrames', 'var')
%                     imshow(recordFrames{t}{1}); % show right camera
%                 end
        stickLoc = recordStickLoc{t};
        [drumSound, lastLoc, params] = ADDecision4_5(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        DisplayPerTimeStamp(stickLoc, recordRectFrames{t}{1}, dispParams);
    end
elseif strcmp(runMode, 'PlayRect')
    load([options.loadStr,'.mat'], 'record');
    if isempty(params)
        load([options.loadStr,'.mat'], 'params');
    end
    
    % unpack record struct
    totalTime = record.totalTime;
    totalFrames = record.totalFrames;
    recordRectFrames = record.frames;
    
    [lastLoc, kf] = ADInitState2(record.frames{2}, params, true); % took second frame pair because first is empty
    rate = totalTime / totalFrames;
    disp(1./rate);
    dispParams = CalcOfflineDispParams(params, recordRectFrames{2}{1});
    profile on
    for t = 2:totalFrames
%                 if exist('recordFrames', 'var')
%                     imshow(recordFrames{t}{1}); % show right camera
%                 end
        [stickLoc, kf] = ADLocationPerTimestep(recordRectFrames{t}, params, 'rectifyFrames', false, 'kalmanFilter', kf);
        [drumSound, lastLoc, params] = ADDecision4_5(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
        DisplayPerTimeStamp(stickLoc, recordRectFrames{t}{1}, dispParams);
    end
    profile viewer
end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end