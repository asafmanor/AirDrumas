function [params] = ADLoadParams(method)
% loads all the default parameters that should be inserted by the user.
% this is the only part where the user should intervene and make changes.
% for example, 'stream' method will set the parameters to decrease quality
% in favor of improved run-time.
% INPUTS: 	method: 'single' for one shot experiments,
%					'video' for a full recording
%					'stream' for a live stream of frames
% OUTPUTS:  params: parameters struct

% load default parameters

% load parameters per dataset (may override defaults)
if strcmp(method, 'single')
	params.numOfSticks = 2;

	% pre-processing params
	params.pp.gausssianFilter.enable = true;
	params.pp.gausssianFilter.sigma = 0.5;
	params.pp.medianFilter.enable = false;
	params.pp.medianFilter.kernel = [3 3];
	params.pp.resize.enable = true;
	params.pp.resize.resizeFactor = 1/2;

	% feature extraction params
	params.features.grad.enable = true;
	params.features.gray.enable = true;
	params.features.edge.enable = false;

	% kalman filter params
	params.kalman.enable = true;
	params.searchPatchSize = [100 100]; % patch size surrounding approximated center
	params.crop_size = [100 100];

	% stereo vision params
	params.stereoCamerasCalib = struct(); % TODO call to stereo camera calibration 
end

end