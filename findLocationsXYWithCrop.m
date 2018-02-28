function [stickLoc, sticksFound] = findLocationsXYWithCrop(frame, refLoc, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks (usually 2)
% INPUTS: 	frame - from main camera
%           refLoc - reference location for crop, depends on method for crop
%			params - parameters struct
% OUTPUTS: 	stickLoc - stickLoc struct

N = params.numOfSticks;
stickLoc = cell(N,1);

sticksFound = zeros(1,N);
performFullFrameSearch = strcmp(params.xy.searchMethod, 'full');

for n = 1:N
    if ~isempty(refLoc) && refLoc{n}.found % was found last time!
        if strcmp(params.xy.searchMethod, 'lastLocCrop')
            [crop, offsetX, offsetY] = cropAroundPoint(frame, [refLoc{n}.x, refLoc{n}.y], params);
        elseif strcmp(params.xy.searchMethod, 'horizontalLine')
            crop = cropHorizontalLine(frame, refLoc{n}.y, params);
            offsetX = 0;
        end
        LABonCrop = rgb2lab(crop);
        [props, largestCC, sticksFound(n)] = performRegionPropsOnMask(LABonCrop, params, n);
        if sticksFound(n)
            centers = cat(1, props.Centroid);
            centers = centers(largestCC, :); % take N biggest elements
            stickLoc{n}.x = centers(1,1) + offsetX;
            stickLoc{n}.y = centers(1,2) + offsetY;
        elseif strcmp(params.xy.searchMethod, 'horizontalLine')
            % in horizontal line method, if we found the stick in the ref image, we MUST find it in this one.
            % otherwise we should'nt even look for it.
            performFullFrameSearch = true;
        end
    end
end

% in lastLocCrop method we will conduct a full frame search if not all sticks were found
performFullFrameSearch = performFullFrameSearch || (strcmp(params.xy.searchMethod, 'lastLocCrop') && ~(all(sticksFound) == true));
if performFullFrameSearch
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

function [crop, x1, y1] = cropAroundPoint(frame, cropCenter, params)
% return the crop image of the cell defined by the cell's COM in size [params.crop.cropSize]
% INPUTS:   frame - image
%           params - parameters struct for the TDG
%           cropCenter - crop around this index  
% OUTPUTS:  crop - crop greyscale image size [params.crop.cropSize] 
%           x1 - shift in x
%           y1 - shift in y

h  = params.xy.cropSize(1);
w  = params.xy.cropSize(2);
y1 = max(round(cropCenter(1)-h/2),1);
y2 = min(round(cropCenter(1)+h/2),size(frame,1));
x1 = max(round(cropCenter(2)-w/2),1);
x2 = min(round(cropCenter(2)+w/2),size(frame,2));
crop = frame(y1:y2, x1:x2, :);
end

function [crop, offsetY] = cropHorizontalLine(frame, y, params)
    dy = params.xy.dy;
    top     = max(y - dy, 1);
    bottom  = min(y + dy, size(frame(1)));
    crop = frame(top:bottom, :);
    offsetY = top; %TODO asaf - validate this is the right offset
end
