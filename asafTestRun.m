clear ; clc ; close all;
global debug;
debug.enable = false;

load('data_capture_2.mat');
% load prameters
params = ADLoadParams('single');

chosenFrames = 45:55;
workVideo1 = A(:,:,:,chosenFrames);
workVideo2 = B(:,:,:,chosenFrames);

% initialize temporal data
N = params.numOfSticks;
temporalData = cell(N,1);
for n=1:2
    temporalData{n}.estimatedLocationExists = false;
end

%% find (x,y,z) locations
clc;
location = cell(length(chosenFrames),1);
for t=1:length(chosenFrames)
    debug.timestep = t;
    frames{1} = frameFromVid(workVideo1, t);
    frames{2} = frameFromVid(workVideo2, t);
    location{t} = ADLocationPerTimestep(frames, params, temporalData);
    
end
function frame = frameFromVid(video, timestep)
    frame = video(:,:,:,timestep);
end