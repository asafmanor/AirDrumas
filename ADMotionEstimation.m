function [estStateVector] = ADMotionEstimation(lastEstStateVector, stickLoc)
% estimate new state vector using kalman filter. state vector is %TODO asaf - which state vector should I use?
% INPUTS: 	stickLoc - stickLoc struct
% INPUTS: 	lastEstStateVector - estimated state vector from previous time-step.
%			stickLoc - current found location (kalman's current measurment).
% OUTPUTS: 	estStateVector - estimated vector

% debug struct
global debug;
% function body

if debug.enable
	% debug.some_parameter = some_parameter;
end

end