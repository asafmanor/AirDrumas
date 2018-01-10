function [estStateVector] = ADMotionEstimation(lastEstStateVector, stickLoc, params)
% estimate new state vector using kalman filter. state vector is %TODO asaf - which state vector should I use?
% INPUTS: 	stickLoc - stickLoc struct
% INPUTS: 	lastEstStateVector - estimated state vector from previous time-step.
%			stickLoc - current found location (kalman's current measurment).
% OUTPUTS: 	estStateVector - estimated vector

N = params.numOfSticks;
if isempty(lastEstStateVector)
	for n = 1:N
		% TODO asaf - add velocity, acceleration data
		estStateVector{n}.x = stickLoc{n}.x;
		estStateVector{n}.y = stickLoc{n}.y;
	end
else
	for n = 1:N
		% kalman filtering!
	end
end