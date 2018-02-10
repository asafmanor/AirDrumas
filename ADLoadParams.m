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
%  location params
params.xmargin = 70;
params.ymargin = 30;
params.zmargin = 10;
params.margin = 5;

for i =1:6
    params.drums{i}.x=0;
    params.drums{i}.y=0;
    params.drums{i}.shift=0;
end
% sound params
params.kit = 0;

% stereo vision params
try
    temp = load('stereoParams.mat');
    params.stereoParams = temp.stereoParams;
catch
    params.stereoParams = struct();
    warning('stereoParams.mat does not exist!');
end

end