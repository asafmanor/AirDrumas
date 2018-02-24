function [stickLoc, sticksFound] = findLocationsXYWithCrop(frame, lastLoc, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks (usually 2)
% INPUTS: 	frame - from main camera
%			params - parameters struct
% OUTPUTS: 	stickLoc - stickLoc struct

N = params.numOfSticks;
stickLoc = cell(N,1);

sticksFound = zeros(1,N);

for n = 1:N
    %break;
    if ~isempty(lastLoc) && lastLoc{n}.found % was found last time! % TODO asaf remove isempty after fix init
        [crop, offsetX, offsetY] = cropForLAB(frame, [lastLoc{n}.x, lastLoc{n}.y], params);
        LABonCrop = rgb2lab(crop);
        [props, largestCC, sticksFound(n)] = performRegionPropsOnMask(LABonCrop, params, n);
        if sticksFound(n)
            centers = cat(1, props.Centroid);
            centers = centers(largestCC, :); % take N biggest elements
            stickLoc{n}.x = centers(1,1) + offsetX;
            stickLoc{n}.y = centers(1,2) + offsetY;
        end
    end
end
% if we didn't find all sticks, perform a full LAB search
if ~(all(sticksFound) == true)
    LABfull = rgb2lab(frame);
end

% if we created a full LAB, look for the sticks we didn't find yet
if exist('LABfull', 'var')
    for n = 1:N
        if sticksFound(n) ~= true
            [props, largestCC, sticksFound(n)] = performRegionPropsOnMask(LABfull, params, n);
            if sticksFound(n)
                centers = cat(1, props.Centroid);
                centers = centers(largestCC, :); % take N biggest elements
                stickLoc{n}.x = centers(1,1);
                stickLoc{n}.y = centers(1,2);
            end
        end
    end
end
end

function [props, largestCC, stickFound] = performRegionPropsOnMask(LAB, params, n)
p = params.xy;
reqProps = {'Centroid', 'Area'};
%imshow((-1)^p.negativeChannel(n) * LAB(:,:,p.maskChannel(n)) > p.maskTh(n));
props = regionprops((-1)^p.negativeChannel(n) * LAB(:,:,p.maskChannel(n)) > p.maskTh(n), reqProps);
if size(props,1) > 1 % more then N connected components
    [~, largestCC] = sort([props.Area], 'descend'); % get biggest elements indices
    largestCC = largestCC(1);
    stickFound = true;
elseif size(props,1) == 1
    largestCC = 1;
    stickFound = true;
else
    largestCC = [];
    stickFound = false;
end
end