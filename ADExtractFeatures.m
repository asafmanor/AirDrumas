function [features] = ADExtractFeatures(frame, params)
% extracts features from a frame
% INPUTS:	params - parameters struct
%			frame - of which we extract features from
% OUTPUTS:	features - struct of features, some of them are matrices, some may be scalars.

% TODO asaf - probably no real use of this function. consider deleting,
% since it operates on the whole frame and is costly in time.
features = struct();

if params.features.gray.enable
	features.gray = rgb2gray(frame);
	if params.features.grad.enable
		features.grad = imgradient(features.gray); % sobel gradient
	end
end
% TODO - add masks based on color / shape?
end