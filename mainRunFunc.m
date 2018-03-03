function saveStr = mainRunFunc(runMode, varargin)
close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
global rectifiedRec
global stats
stats.ffs = 0;
stats.nffs = 0;

p = inputParser;
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
    lastLoc = ADInitState2(frames, params);
    if options.recordStickLoc
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
    
    % test - asaf
    % params.xy.searchMethod = 'full';
    % params.xy.dy = 15;
    % params.xy.maskTh = [55 25]; % red, blue
    % params.xy.maskChannel = [2 3]; % A, B channels
    % params.xy.negativeChannel = [0 1];
    % params.numOfSticks = 1;
    % test - asaf
    
    % unpack record struct
    totalTime = record.totalTime;
    totalFrames = record.totalFrames;
    recordRectFrames = record.frames;
    
    lastLoc = ADInitState2(record.frames{2}, params, true); % took second frames because first is empty
    rate = totalTime / totalFrames;
    dispParams = CalcOfflineDispParams(params, recordRectFrames{2}{1});
    %test - asaf
    profile on
    for t = 2:totalFrames
%                 if exist('recordFrames', 'var')
%                     imshow(recordFrames{t}{1}); % show right camera
%                 end
        stickLoc = ADLocationPerTimestep(recordRectFrames{t}, params, 'rectifyFrames', false);
        [drumSound, lastLoc, params] = ADDecision4_5(stickLoc, params, lastLoc);
        ADSound2(drumSound, params);
%        DisplayPerTimeStamp(stickLoc, recordRectFrames{t}{1}, dispParams);
    end
    %test - asaf
    profile viewer
end
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end