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
params.numOfSticks = 1;
params.framesForHeightCalibration = 10;

% pre-processing params
params.pp.gausssianFilter.enable = false;
params.pp.gausssianFilter.sigma = 0.5;
params.pp.medianFilter.enable = false;
params.pp.medianFilter.kernel = [3 3];
params.pp.resize.enable = true;
params.pp.resize.resizeFactor = 1/4;

% xy location params
params.xy.redMaskTh = 40;
params.xy.blueMaskTh = -20;
% z location params

% sound params
params.hightH = 70;
params.hightL = 30;
params.hightL = 10;
params.kit = 0;
params.margin = 5;
% stereo vision params
try
    temp = load('stereoParams.mat');
    params.stereoParams = temp.stereoParams;
catch
    params.stereoParams = struct();
    warning('stereoParams.mat does not exist!');
end

end