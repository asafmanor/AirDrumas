function [stickLoc] = ADFindLocationsXY(frame, temporalData, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks (usually 2)
% INPUTS: 	frame - from main camera
%			params - parameters struct
%			temporalData - cell array of n*2 containing structs of containing all relevant data from previous time-step
% OUTPUTS: 	stickLoc - stickLoc struct

% parse estimated location
N = params.numOfSticks;
stickLoc = cell(N,1);
for n = 1:N
	if temporalData{n}.estimatedLocationExists
		% crop around estimated location
		[x y] = [temporalData.estStateVector(n).x, temporalData.estStateVector(n).y];
		imageCrop = CropImage(frame, [x y], params);
		% find new location in crop
    else
        % test - asaf: assigining values just for compilation
        stickLoc{n}.x = 1; stickLoc{n}.y = 1; 
    end
end
end