clear ; close all;
global debug;
debug.enable = false;

params = ADLoadParams();
addpath('Samples');

camL = webcam(2);
camR = webcam(3);
ADInitializeRecordingSession(camR, camL, params)

input('Press any key when ready');

% init state for drum machine
frames{2} = snapshot(camL); % #2 is left camera!
frames{1} = snapshot(camR);
drumState = ADInitstate(frames, params);
%%

global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~KEY_IS_PRESSED
    drawnow
    frames{2} = snapshot(camL); % #2 is left camera!
    frames{1} = snapshot(camR);
    stickLoc = ADLocationPerTimestep(frames, params);
    fprintf('x = %.1f, y = %.1f, shift = %.1f\n', stickLoc{1}.x, stickLoc{1}.y, stickLoc{1}.shift);
    %[drumSound, drumState] = ADDecision(stickLoc, params, drumState);
    %ADSound(drumSound, params.kit);
end
disp('Run Finished! Hope you had a jolly good time')

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end