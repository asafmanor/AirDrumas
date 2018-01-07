function [features] = ADExtractFeatures(frame, params)
% extracts features from a frame
% INPUTS:	params - parameters struct
%			frame - of which we extract features from
% OUTPUTS:	features - struct of features, some of them are matrices, some may be scalars.

if strcmp(source_type, 'frame')
	sobel                    = fspecial('sobel');
	features.sobelHorizontal = imfilter(frame, sobel_h);
	features.sobelVertical   = imfilter(frame, sobel_h.');
	features.grad            = sqrt(features.sobel_horizontal.^2 + features.sobel_vertical.^2);
	% TODO - add masks based on color / shape?
end
end