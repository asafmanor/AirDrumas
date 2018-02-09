function [stickLoc] = ADFindLocationsXY(frame, params)
% returns stickLoc(n).x and stickLoc(n).y for n sticks (usually 2)
% INPUTS: 	frame - from main camera
%			params - parameters struct
% OUTPUTS: 	stickLoc - stickLoc struct

% parse estimated location
N = params.numOfSticks;
stickLoc = cell(N,1);

LAB = rgb2lab(frame);
%tic
A = LAB(:,:,2);
% disp('LAB time:')
%toc
reqProps = {'Centroid', 'Area'};
%tic
props = regionprops(A > params.xy.maskTh, reqProps);
% disp('regionprops time:')
%toc
if size(props,1) > N % more then N connected components
    [~, largestCC] = sort([props.Area], 'descend'); % get biggest elements indices
    largestCC = largestCC(1:N);
elseif size(props,1) == N
    largestCC = 1:N;
else
    error('found only %d connected components in mask', size(props,1));
end
centers = cat(1, props.Centroid);
centers = centers(largestCC, :); % take N biggest elements
for n = 1:N
    stickLoc{n}.x = centers(n,1);
    stickLoc{n}.y = centers(n,2);        
end
end