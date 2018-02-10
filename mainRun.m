clear ; close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;

global calib
calib.enable = true;

addpath('Samples');
params = ADLoadParams();
runMode = 'live';

% test asaf
load paramsAsaf.mat
params.numOfSticks = 2;
params.playerPosition = [210 0];
params.drums{1}.shift = 66;
params.drums{2}.shift = 70;
params.drums{3}.shift = 73;
params.drums{4}.shift = 74;
params.minAngle = 5;
params.maxAngle = 170;
params.numOfDrums = 3;
% test - asaf

if strcmp(runMode, 'live')
	camR = webcam(2);
	camL = webcam(3);
    %ADInitializeRecordingSession(camR, camL, params)

	% init state for drum machine
    frames{1} = snapshot(camR);
	frames{2} = snapshot(camL); % #2 is left camera!
	lastLoc = ADInitState2(frames, params);

	gcf
	set(gcf, 'KeyPressFcn', @myKeyPressFcn)
    preview(camR);
    input('Ready when you are! Press any key to start playing ');
    historyR = []; historyL = [];
	while ~KEY_IS_PRESSED
	    drawnow
	    frames{2} = snapshot(camL); % #2 is left camera!
	    frames{1} = snapshot(camR);
	    stickLoc = ADLocationPerTimestep(frames, params);
	    %[drumSound, drumState] = ADDecision(stickLoc, params, drumState);
	    [drumSound, lastLoc] = ADDecision3(stickLoc, params, lastLoc);
	    ADSound2(drumSound, params);
    end
elseif strcmp(runMode, 'video')
% 	load leftArray;
% 	load rightArray;
%     %ADInitializeRecordingSession(camR, camL, params)

% 	% init state for drum machine 
% 	frames{2} = leftArray(:,:,:,1); % #2 is left camera!
% 	frames{1} = rightArray(:,:,:,1);
% 	drumState = ADInitstate(frames, params);
% 	%% run!	

% 	global KEY_IS_PRESSED
% 	KEY_IS_PRESSED = 0;
% 	gcf
% 	set(gcf, 'KeyPressFcn', @myKeyPressFcn)
% 	while ~KEY_IS_PRESSED
% %         tic
% 	    drawnow
% 	    frames{2} = snapshot(camL); % #2 is left camera!
% 	    frames{1} = snapshot(camR);
% 	    stickLoc = ADLocationPerTimestep(frames, params);
%         if stickLoc{1}.found
%             fprintf('stick #1: x = %.1f, y = %.1f, shift = %3.3f\n', stickLoc{1}.x, stickLoc{1}.y, stickLoc{1}.shift);
%         end
%         if stickLoc{2}.found
%             fprintf('stick #2: x = %.1f, y = %.1f, shift = %3.3f\n', stickLoc{2}.x, stickLoc{2}.y, stickLoc{2}.shift);
%         end
% 	    [drumSound, drumState] = ADDecision(stickLoc, params, drumState);
% 	    ADSound(drumSound, params.kit);
%     end
%     close;
% 	disp('Run Finished! Hope you had a jolly good time')
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end