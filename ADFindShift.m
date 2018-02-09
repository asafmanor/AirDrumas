function [stickLoc{1}] = ADFindShift(stickLoc)
% function description
% INPUTS: 	parameter1 -
%			parameter2 - 
% OUTPUTS: 	result - 

% debug struct
global debug;
% function body
N = params.numOfSticks
for n = 1:N
	stickLoc{1}{n}.shift = abs(stickLoc{1}{n}.x-stickLoc{2}{n}.x);
end

% debug dump
if debug.enable
	t = debug.timestep;
	% debug.some_parameter = some_parameter;
end

end