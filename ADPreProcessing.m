function [ppFrame] = ADPreProcessing(frame,params)
% performs pre-processing of the frame for easier feature extraction
% INPUTS: 	frame - on which we are working on
%			params - parameters struct
% OUTPUTS: 	ppFrame - pre-processed frame, might be different size

ppFrame = frame;
if params.pp.resize.enable
	ppFrame = imresize(ppFrame, params.pp.resize.resizeFactor);
end
end