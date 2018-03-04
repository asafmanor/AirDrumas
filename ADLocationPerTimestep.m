function [stickLoc, kf] = ADLocationPerTimestep(frames, params, varargin)
% given two frames acquired from the two cameras, and extra data extracted
% from previous frames such as estimated stickLoc, this function runs all necessary
% processes such as pre-processing, stick location finding and depth extraction.
% the function returns the stickLoc in terms of [x,y,z] of the points of interest
% INPUTS: 	frames - cell array of frames extracted from main and slave cameras, respectively
%			params - parameters struct
% OUTPUTS:	stickLoc - array of stickLoc struct for each point of interest (usually 2)
%			stated in stickLoc(n).x, stickLoc(n).y, stickLoc(n).z

% important assumptions: this function is called after stereo cameras have been calibrated.
% calibration object is stored in params.calib

% pre-process, extract features
global rectifiedRec

p = inputParser;
p.StructExpand = false;
addParameter(p, 'displayAnaglyph', false);
addParameter(p, 'rectifyFrames', true);
addParameter(p, 'lastLoc', []);
addParameter(p, 'kalmanFilter', []);
parse(p, varargin{:});
options = p.Results;

if options.rectifyFrames
    pp_frames = cellfun(@(x) ADPreProcessing(x, params), frames, 'UniformOutput', false);
    [rect_frames{2}, rect_frames{1}] = rectifyStereoImages(pp_frames{2}, pp_frames{1}, params.stereoParams);
else
    rect_frames = frames;
end
rectifiedRec = rect_frames;

if options.displayAnaglyph
    a = figure;
    [rect_frames_tmp{2}, rect_frames_tmp{1}] = rectifyStereoImages(frames{2}, frames{1}, params.stereoParams);
    imshow(stereoAnaglyph(rect_frames_tmp{1}, rect_frames_tmp{2})); title('Rectified Anaglyph');
    b = figure;
    imshow(rect_frames_tmp{1}); title ('Rectified Frame #1');
    key = input('if Anaglyph is not aligned, enter t to terminate\n', 's');
    if strcmp(key, 't')
        close all;
        error('cameras are not calibrated, try to switch cameras or re-calibrate');
    end
    close(a); close(b);
end

switch params.xy.searchMethod
    case 'lastLocCrop'
        [stickLocRight, sticksFoundRight] = findLocationsXYWithCrop(rect_frames{1}, options.lastLoc, params);
        [stickLocLeft, sticksFoundLeft]   = findLocationsXYWithCrop(rect_frames{2}, options.lastLoc, params);
    case 'horizontalLine'
        [stickLocRight, sticksFoundRight] = findLocationsXYWithCrop(rect_frames{1}, [], params);
        [stickLocLeft, sticksFoundLeft]   = findLocationsXYWithCrop(rect_frames{2}, stickLocRight, params);
    case 'full'
        [stickLocRight, sticksFoundRight] = findLocationsXYWithCrop(rect_frames{1}, [], params);
        [stickLocLeft, sticksFoundLeft]   = findLocationsXYWithCrop(rect_frames{2}, [], params);
    otherwise
        error('searchMethod is not recognized');
end

sticksFound = sticksFoundLeft .* sticksFoundRight; % a vector of two boolean elements
stickLoc = ADFindShift({stickLocRight, stickLocLeft}, sticksFound);

if ~isempty(options.kalmanFilter)
    kf = options.kalmanFilter;
    if params.kalman.enable
        for n = 1:params.numOfSticks
            if stickLoc{n}.found
                predict(kf{n});
                correctedLocation = correct(kf{n}, convertLocationToVec(stickLoc{n}));
            else
                correctedLocation = predict(kf{n});
            end
            stickLoc{n} = convertVecToLocation(correctedLocation);
            stickLoc{n}.found = true;
        end
    end
end
end