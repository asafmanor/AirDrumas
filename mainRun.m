clear ; close all; clc;
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
global debug;
debug.enable = false;
addpath('Samples');

params = ADLoadParams();
runMode = 'live';

%load paramsAsaf.mat
%params.numOfSticks = 2;

if strcmp(runMode, 'live')
	camR = webcam(2);
	camL = webcam(3);
    params = quickSystemAssembly(params, camR, camL);
    %ADInitializeRecordingSession(camR, camL, params)

	% init state for drum machine 
	frames{2} = snapshot(camL); % #2 is left camera!
	frames{1} = snapshot(camR);
	lastLoc = ADInitState2(frames, params);
	%% run!

	gcf
	set(gcf, 'KeyPressFcn', @myKeyPressFcn)
    preview(camR);
    input('Ready when you are! Press any key to start playing ');
    t = 0;
    historyR = []; historyL = [];
	while ~KEY_IS_PRESSED
        t = t + 1;
        disp(t)
	    drawnow
	    frames{2} = snapshot(camL); % #2 is left camera!
	    frames{1} = snapshot(camR);
	    stickLoc = ADLocationPerTimestep(frames, params);
        if stickLoc{1}.found && t < 30
            loc = [stickLoc{1}.x stickLoc{1}.y stickLoc{1}.shift];
            historyR = [historyR ; loc];
        end
        if stickLoc{2}.found && t < 30
            loc = [stickLoc{2}.x stickLoc{2}.y stickLoc{2}.shift];
            historyL = [historyL ; loc];
        end
	    %[drumSound, drumState] = ADDecision(stickLoc, params, drumState);
	    [drumSound, lastLoc] = ADDecision2(stickLoc, params, lastLoc);
	    ADSound2(drumSound, params);
        if t == 30 
            %break;
        end
    end
    close;
    figure; plot3(historyR(:,1), historyR(:,2), historyR(:,3), 'LineWidth', 3);
    xlabel('x');
    ylabel('y');
    zlabel('shift');
    grid on;
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