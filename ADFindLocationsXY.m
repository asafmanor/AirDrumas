function [stickLoc, sticksFound] = ADFindLocationsXY(frame, params)
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
props = regionprops(A > params.xy.redMaskTh, reqProps);
% test - asaf
%figure(1); imshow(A > params.xy.redMaskTh);

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
if redStickFound
    centers = cat(1, props.Centroid);
    centers = centers(largestCC, :); % take N biggest elements
    stickLoc{1}.x = centers(1,1);
    stickLoc{1}.y = centers(1,2);
end

if N == 2
	props = regionprops(B < params.xy.blueMaskTh, reqProps);
    % test - asaf
    %figure(2); imshow(B < params.xy.blueMaskTh);
    
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
    if blueStickFound
        centers = cat(1, props.Centroid);
        centers = centers(largestCC, :); % take N biggest elements
        stickLoc{2}.x = centers(1,1);
        stickLoc{2}.y = centers(1,2);
    end
end

sticksFound = [redStickFound, blueStickFound];

end