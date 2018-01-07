function [ppFrame] = ADFunctionTemplate(frame, ,params)
% performs pre-processing of the frame for easier feature extraction
% INPUTS: 	frame - on which we are working on
%			params - parameters struct
% OUTPUTS: 	ppFrame - pre-processed frame, might be different size

% debug struct
global debug;
ppFrame = frame;
if params.pp.downscale.enable
	ppFrame = imresize(ppFrame,2);
end
if params.pp.gausssianFilter.enable
	ppFrame = imgaussfilt(ppFrame, params.pp.gausssianFilter.sigma);
end
if params.pp.medianFilter.enable
	ppFrame = medfilt2(ppFrame, params);
end
if params.pp.resizeFac.enable
	ppFrame = imresize(ppFrame, params.pp.resizeFactor);
end
% debug dump
if debug.enable
end

end