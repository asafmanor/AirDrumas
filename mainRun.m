clear ; close all; clc;
global debug;
debug.enable = false;

params = ADLoadParams();
addpath('Samples');
runMode = 'live';
params = quickDrumLocations(params);

if strcmp(runMode, 'live')
	camL = webcam(3);
	camR = webcam(2);
	input('Press any key when ready to init ');
    %ADInitializeRecordingSession(camR, camL, params)

	% init state for drum machine 
	frames{2} = snapshot(camL); % #2 is left camera!
	frames{1} = snapshot(camR);
	drumState = ADInitstate(frames, params);
	%% run!	

	global KEY_IS_PRESSED
	KEY_IS_PRESSED = 0;
	gcf
	set(gcf, 'KeyPressFcn', @myKeyPressFcn)
    preview(camL);
    preview(camR);
	while ~KEY_IS_PRESSED
%         tic
	    drawnow
	    frames{2} = snapshot(camL); % #2 is left camera!
	    frames{1} = snapshot(camR);
	    stickLoc = ADLocationPerTimestep(frames, params);
        if stickLoc{1}.found
            fprintf('stick #1: x = %.1f, y = %.1f, shift = %3.3f\n', stickLoc{1}.x, stickLoc{1}.y, stickLoc{1}.shift);
        end
        if stickLoc{2}.found
            fprintf('stick #2: x = %.1f, y = %.1f, shift = %3.3f\n', stickLoc{2}.x, stickLoc{2}.y, stickLoc{2}.shift);
        end
	    [drumSound, drumState] = ADDecision(stickLoc, params, drumState);
	    ADSound(drumSound, params.kit);
    end
    close;
	disp('Run Finished! Hope you had a jolly good time')
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