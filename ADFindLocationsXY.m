function [stickLoc] = ADFindLocationsXY(frame, temporalData, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks (usually 2)
% INPUTS: 	frame - from main camera
%			params - parameters struct
%			temporalData - struct containing all relevant data from previous time-step
% OUTPUTS: 	stickLoc - stickLoc struct

% parse estimated location
for n = [1 2]
	if temporalData.estimatedLocationExists(n)
		[x y] = [temporalData.estStateVector(n).x, temporalData.estStateVector(n).x];
		imageCrop = CropImage(frame, [x y], params);
		% find new location in crop...
	end


end
% debug struct
global debug;
% function body

% debug dump
if debug.enable
	% debug.some_parameter = some_parameter;
end

end