function [stickLoc, numOfSticksFound] = ADFindLocationsXY(frame, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks (usually 2)
% INPUTS: 	frame - from main camera
%			params - parameters struct
% OUTPUTS: 	stickLoc - stickLoc struct

% parse estimated location
N = params.numOfSticks;
stickLoc = cell(N,1);
LAB = rgb2lab(frame);
A = LAB(:,:,2);
B = LAB(:,:,3);
reqProps = {'Centroid', 'Area'};
blueStickFound = false;
redStickFound  = false;

% first, look for the red stick:
redStickFound = true;
props = regionprops(A > params.xy.redMaskTh, reqProps);
if size(props,1) > 1 % more then N connected components
    [~, largestCC] = sort([props.Area], 'descend'); % get biggest elements indices
    largestCC = largestCC(1);
    redStickFound = true;
elseif size(props,1) == 1
    largestCC = 1;
    redStickFound = true;
else
    warning('Red stick was not found in the picture');
end
centers = cat(1, props.Centroid);
centers = centers(largestCC, :); % take N biggest elements
stickLoc{1}.x = centers(1,1);
stickLoc{1}.y = centers(1,2);

if N == 2
	props = regionprops(B < params.xy.blueMaskTh, reqProps);
	if size(props,1) > 1 % more then N connected components
    	[~, largestCC] = sort([props.Area], 'descend'); % get biggest elements indices
    	largestCC = largestCC(1);
    	blueStickFound = true;
	elseif size(props,1) == 1
    	largestCC = 1;
    	blueStickFound = true;
	else
    	warning('Blue stick was not found in the picture');
	end
	centers = cat(1, props.Centroid);
	centers = centers(largestCC, :); % take N biggest elements
	stickLoc{2}.x = centers(1,1);
	stickLoc{2}.y = centers(1,2);
end

numOfSticksFound = blueStickFound + redStickFound;

end