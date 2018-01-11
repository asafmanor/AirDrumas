function [stickLoc] = ADFindLocationsZ(frames, stickLoc, params)
% returns stickLoc(n).z for n sticks (usually 2)
% INPUTS: 	frames - from both cameras
%			params - parameters struct
%			stickLoc - contains stickLoc(n).x and stickLoc(n).y with respect to frames(1)
% OUTPUTS: 	stickLoc - stickLoc struct

% parse inputs
N = params.numOfSticks;
x = zeros(N,1); y = zeros(N,1);
for n = 1:N
	x(n) = stickLoc{n}.x;
	y(n) = stickLoc{n}.y;
end
calib = params.calib;

% debug struct
global debug;
% function body

% debug dump
if debug.enable
	% debug.some_parameter = some_parameter;
end

end