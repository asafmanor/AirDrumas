function [updatedTemporalData, stickLoc] = ADLocationPerTimestep(frames, params, temporalData)
% given two frames acquired from the two cameras, and extra data extracted
% from previous frames such as estimated stickLoc, this function runs all necessary 
% processes such as pre-processing, stick location finding and depth extraction.
% the function returns the stickLoc in terms of [x,y,z] of the points of interest
% INPUTS: 	frames - cell array of frames extracted from main and slave cameras, respectively
%			params - parameters struct
%			temporalData - struct containing all relevant data from previous time-step
% OUTPUTS: 	updatedtemporalData - struct containing all relevant data of this time-step
%			stickLoc - array of stickLoc struct for each point of interest (usually 2)
%			stated in stickLoc(n).x, stickLoc(n).y, stickLoc(n).z

% important assumptions: this function is called after stereo cameras have been calibrated.
% calibration object is stored in params.calib

global debug;
% pre-process, extract features
pp_frames = cellfun(@(x) ADPreProcessing(x, params), frames, 'UniformOutput', false);
% find current stickLoc in (x,y)
stickLoc = ADFindLocationsXY(pp_frames{1}, temporalData, params);
stickLoc = ADFindLocationsZ(pp_frames, stickLoc, params);

% estimate next state vector using current stickLoc and state vector
N = params.numOfSticks;

updatedTemporalData = temporalData;
if temporalData.estimatedLocationExists
    for n = 1:N
        lastEstStateVector = temporalData.estStateVector{n};
        updatedTemporalData.estStateVector{n} = ADMotionEstimation(lastEstStateVector, stickLoc, params);
    end
else
    for n = 1:N
        updatedTemporalData.estStateVector{n} = ADMotionEstimation([], stickLoc, params);
    end
end

% debug dump
if debug.enable
	t = debug.timestep;
	debug.pp_frames{t} = pp_frames;
	debug.stickLoc{t} = stickLoc;
	debug.features{t} = features;
end

end