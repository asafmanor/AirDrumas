function [updatedTemporalData, stickLoc] = ADLocationPerTimestep(frames, params, temporalData)
% given two frames acquired from the two cameras, and extra data extracted
% from previous frames such as estimated stickLoc, this function runs all necessary 
% processes such as pre-processing, stick location finding and depth extraction.
% the function returns the stickLoc in terms of [x,y,z] of the points of interest
% INPUTS: 	frames - cell array of frames extracted from main and slave cameras, respectively
%			params - parameters struct
%			temporalData - cell array of n*2 containing structs of containing all relevant data from previous time-step
% OUTPUTS: 	updatedtemporalData - cell array of n*2 containing structs of containing all relevant data of this time-step
%			stickLoc - array of stickLoc struct for each point of interest (usually 2)
%			stated in stickLoc(n).x, stickLoc(n).y, stickLoc(n).z

% important assumptions: this function is called after stereo cameras have been calibrated.
% calibration object is stored in params.calib

global debug;
% pre-process, extract features
pp_frames = cellfun(@(x) ADPreProcessing(x, params), frames, 'UniformOutput', false);
features  = cellfun(@(x) ADExtractFeatures(x, params), frames, 'UniformOutput', false);
% find current stickLoc in (x,y)
stickLoc = ADFindLocationsXY(frames(1), temporalData, params);
stickLoc = ADFindLocationsZ(frames, stickLoc, params);

% estimate next state vector using current stickLoc and state vector
% todo asaf - add parameter in temporalData specifiying if a state vector exists
N = params.numOfSticks;

updatedTemporalData = cell(N,1);
for n = 1:N
    if temporalData{n}.estimatedLocationExists
        lastEstStateVector = temporalData{n}.estStateVector;
        updatedTemporalData{n}.estStateVector = ADMotionEstimation(lastEstStateVector, stickLoc, params);
    else
        updatedTemporalData{n}.estStateVector = ADMotionEstimation([], stickLoc, params);
    end
end

% debug dump
if debug.enable
	t = debug.timestep;
	debug.pp_frames(t) = pp_frames;
	debug.stickLoc(t) = stickLoc;
	debug.features(t) = features;
end

end