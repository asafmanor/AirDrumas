function [stickLoc, sticksFound] = findLocationsXYWithCrop(frame, refLoc, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks
% INPUTS: 	frame - from main camera
%           refLoc - reference location for crop, depends on method for crop
%			params - parameters struct
% OUTPUTS: 	stickLoc - stickLoc struct
global stats

N = params.numOfSticks;
stickLoc = cell(N,1);

sticksFound = zeros(1,N);
% on horizontalLine method we call findLocationsXYWithCrop
% with an empty refLoc on the first (right) frame
fullFrameSearch = strcmp(params.xy.searchMethod, 'full') || ...
    (strcmp(params.xy.searchMethod, 'horizontalLine') && isempty(refLoc));

switch params.xy.searchMethod
    case 'lastLocCrop'
        warning('lastLocCrop is not recommended for use! very buggy. press any key to continue');
        input('');
        for n = 1:N
            if ~isempty(refLoc) && refLoc{n}.found
                [crop, offsetX, offsetY] = cropAroundPoint(frame, [refLoc{n}.x, refLoc{n}.y], params);
                YCbCrOnCrop = rgb2ycbcr(crop);
                HsvOnCrop   = rgb2hsv(crop);
                [props, largestCC, sticksFound(n)] = performRegionPropsOnMask(YCbCrOnCrop, HsvOnCrop, params, n);
                if sticksFound(n)
                    centers = cat(1, props.Centroid);
                    centers = centers(largestCC, :); % take N biggest elements
                    stickLoc{n}.x = centers(1,1) + offsetX;
                    stickLoc{n}.y = centers(1,2) + offsetY;
                end
                if ~(all(sticksFound) == true)
                    fullFrameSearch = true;
                end
            end
        end
    case 'horizontalLine'
        maxY = 1;
        minY = size(frame,1);
        for n = 1:N
            if ~isempty(refLoc) && refLoc{n}.foundXY
                maxY = max(maxY, refLoc{n}.y);
                minY = min(minY, refLoc{n}.y);
            end
        end
        if minY ~= inf %we have found at least 1 stick
            [crop, offsetY] = cropHorizontalLine(frame, minY, maxY, params);
            YCbCrOnCrop = rgb2ycbcr(crop);
            HsvOnCrop   = rgb2hsv(crop);
            for n = 1:N
                if ~isempty(refLoc) && refLoc{n}.foundXY
                    [props, largestCC, sticksFound(n)] = performRegionPropsOnMask(YCbCrOnCrop, HsvOnCrop, params, n);
                    if sticksFound(n)
                        centers = cat(1, props.Centroid);
                        centers = centers(largestCC, :); % take N biggest elements
                        stickLoc{n}.x = centers(1,1);
                        stickLoc{n}.y = centers(1,2) + offsetY;
                    else
                        % in horizontal line method, if we found the stick in the ref image
                        % we MUST find it in this one.
                        fullFrameSearch = true;
                    end
                end
            end
        end
    case 'full'
        fullFrameSearch = true;
    otherwise
        error('unknown search method')
end

if fullFrameSearch
    YCbCrFull = rgb2ycbcr(frame);
    HsvFull   = rgb2hsv(frame);
end
if ~isempty(refLoc)
    if fullFrameSearch
        stats.ffs = stats.ffs + 1;
    else
        stats.nffs = stats.nffs + 1;
    end
end

% if we created a full YCbCr, look for the sticks we didn't find yet
if exist('YCbCrFull', 'var')
    for n = 1:N
        if sticksFound(n) ~= true
            [props, largestCC, sticksFound(n)] = performRegionPropsOnMask(YCbCrFull, HsvFull, params, n);
            if sticksFound(n)
                centers = cat(1, props.Centroid);
                centers = centers(largestCC, :); % take N biggest elements
                stickLoc{n}.x = centers(1,1);
                stickLoc{n}.y = centers(1,2);
                stickLoc{n}.foundXY = true;
            else
                stickLoc{n}.foundXY = false;
            end
        end
    end
end
end

function [props, largestCC, stickFound] = performRegionPropsOnMask(YCbCr, Hsv, params, n)
p = params.xy;
reqProps = {'Centroid', 'Area'};
% figure;
% imshow(((-1)^p.negativeChannel(n) * YCbCr(:,:,p.maskChannel(n)) > p.maskThYCbCr(n)) & (Hsv(:,:,2) > p.maskThHsv));
% figure;
% imshow(Hsv(:,:,2));
props = regionprops(((-1)^p.negativeChannel(n) * YCbCr(:,:,p.maskChannel(n)) > p.maskThYCbCr(n)) & (Hsv(:,:,2) > p.maskThHsv), reqProps);
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

function [crop, offsetX, offsetY] = cropAroundPoint(frame, cropCenter, params)
h  = params.xy.cropSize(1);
w  = params.xy.cropSize(2);
y1 = max(round(cropCenter(1)-h/2),1);
y2 = min(round(cropCenter(1)+h/2),size(frame,1));
x1 = max(round(cropCenter(2)-w/2),1);
x2 = min(round(cropCenter(2)+w/2),size(frame,2));
crop = frame(y1:y2, x1:x2, :);
offsetX = x1 - 1;
offsetY = y1 - 1;
end

function [crop, offsetY] = cropHorizontalLine(frame, minY, maxY, params)
dy = params.xy.dy;
top     = max(round(minY - dy), 1);
bottom  = min(round(maxY + dy), size(frame,1));
crop = frame(top:bottom, :, :);
offsetY = top - 1;
end