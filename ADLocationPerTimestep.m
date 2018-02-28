function [stickLoc] = ADLocationPerTimestep(frames, params, displayAnaglyph, lastLoc)
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

if ~exist('displayAnaglyph','var')
    displayAnaglyph = false;
end

pp_frames = cellfun(@(x) ADPreProcessing(x, params), frames, 'UniformOutput', false);
[rect_frames{2}, rect_frames{1}] = rectifyStereoImages(pp_frames{2}, pp_frames{1}, params.stereoParams);
rectifiedRec = rect_frames;

if displayAnaglyph
    figure;
    [rect_frames_tmp{2}, rect_frames_tmp{1}] = rectifyStereoImages(frames{2}, frames{1}, params.stereoParams);
    imshow(stereoAnaglyph(rect_frames_tmp{1}, rect_frames_tmp{2}));title('Rectified images');
    key = input('if Anaglyph is not aligned, enter t to terminate\n', 's');
    if strcmp(key, 't')
        error('cameras are not calibrated, try to switch cameras or re-calibrate');
    end
    close;
end

switch params.xy.searchMethod
	case 'lastLocCrop'
		[stickLocRight, sticksFoundRight] = findLocationsXYWithCrop(rect_frames{1}, lastLoc, params);
		[stickLocLeft, sticksFoundLeft]   = findLocationsXYWithCrop(rect_frames{2}, lastLoc, params);
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

end