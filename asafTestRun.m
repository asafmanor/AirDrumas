clear ; close all;
global debug;
debug.enable = true;

load('data_capture_2.mat');
% load prameters
params = ADLoadParams('single');

chosenFrames = 45:55;
workVideo1 = A(:,:,:,chosenFrames);
workVideo2 = B(:,:,:,chosenFrames);

% initialize temporal data
N = params.numOfSticks;
temporalData.estimatedLocationExists = false;

%% find (x,y,z) locations
location = cell(length(chosenFrames),1);
tic
for t=1:length(chosenFrames)
    debug.timestep = t;
    % extract timesteps
    frames{1} = frameFromVid(workVideo1, t);
    frames{2} = frameFromVid(workVideo2, t);
    [temporalData, location{t}] = ADLocationPerTimestep(frames, params, temporalData);
end
toc
% here we should implement the decision maker based on all locations.

function frame = frameFromVid(video, timestep)
    frame = video(:,:,:,timestep);
end