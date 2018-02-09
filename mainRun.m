clear ; close all;
global debug;
debug.enable = false;

params = ADLoadParams('single');
cams(1) = webcam(2);
cams(2) = webcam(3);

input('Please sit in the drummer\'s chair and hold the sticks at waist height. press any key to continue');
for t=1:params.framesForHeightCalibration
	frames{1} = snapshot(cams(1));
	frames{2} = snapshot(cams(2));
	% TODO asaf - add averging of height
end
% initialize temporal data
N = params.numOfSticks;

%% find (x,y,z) locations
location = cell(length(chosenFrames),1);
profile on
for t=1:length(chosenFrames)
    debug.timestep = t;
    % extract timesteps
    frames{1} = frameFromVid(workVideo1, t);
    frames{2} = frameFromVid(workVideo2, t);
    [temporalData, location{t}] = ADLocationPerTimestep(frames, params, temporalData);
end
profile viewer
% here we should implement the decision maker based on all locations.

function frame = frameFromVid(video, timestep)
    frame = video(:,:,:,timestep);
end