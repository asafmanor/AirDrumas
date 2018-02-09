function [params] = ADLoadParams()
% loads all the default parameters that should be inserted by the user.
% this is the only part where the user should intervene and make changes.
% for example, 'stream' method will set the parameters to decrease quality
% in favor of improved run-time.
% INPUTS: 	method: 'single' for one/several shot experiments,
%					'stream' for a live stream of frames
% OUTPUTS:  params: parameters struct

% load default parameters

% load parameters per dataset (may override defaults)
params.numOfSticks = 2;
params.framesForHeightCalibration = 10;

% pre-processing params
params.pp.gausssianFilter.enable = false;
params.pp.gausssianFilter.sigma = 0.5;
params.pp.medianFilter.enable = false;
params.pp.medianFilter.kernel = [3 3];
params.pp.resize.enable = true;
params.pp.resize.resizeFactor = 1/2;

% xy location params
params.xy.maskTh = 30;

% kalman filter params
params.kalman.enable = false;
params.crop_size = params.pp.resize.resizeFactor*[100 100];

% stereo vision params
try
    params.stereoParames = load('stereoParams.mat');
catch
    params.stereoParames = struct();
    warning('stereoParams.mat does not exist!');
end

end