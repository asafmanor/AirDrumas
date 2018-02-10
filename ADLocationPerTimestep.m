function [stickLoc] = ADLocationPerTimestep(frames, params)
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

global debug;
% pre-process, extract features
pp_frames = cellfun(@(x) ADPreProcessing(x, params), frames, 'UniformOutput', false);
[rect_frames{2}, rect_frames{1}] = rectifyStereoImages(pp_frames{2}, pp_frames{1}, params.stereoParams);

[stickLocRight, N1] = ADFindLocationsXY(rect_frames{1}, params);
[stickLocLeft, N2]  = ADFindLocationsXY(rect_frames{2}, params);
stickLoc = ADFindShift({stickLocRight, stickLocLeft}, min(N1,N2));

% debug dump
if debug.enable
	t = debug.timestep;
	debug.pp_frames{t} = pp_frames;
	debug.stickLoc{t} = stickLoc;
end

end