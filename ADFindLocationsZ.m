function [stickLoc] = ADFindLocationsZ(frames, stickLoc, params)
% returns stickLoc(n).z for n sticks (usually 2)
% INPUTS: 	frames - from both cameras
%			params - parameters struct
%			stickLoc - contains stickLoc(n).x and stickLoc(n).y with respect to frames(1)
% OUTPUTS: 	stickLoc - stickLoc struct

% parse inputs
[x1,y1] = [stickLoc(1).x, stickLoc(1).y];
[x2,y2] = [stickLoc(2).x, stickLoc(2).y];
stereoCamerasCalib = params.stereoCamerasCalib;

% debug struct
global debug;
% function body

% debug dump
if debug.enable
	% debug.some_parameter = some_parameter;
end

end