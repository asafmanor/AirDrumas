clear ; close all;
global debug;
debug.enable = false;

params = ADLoadParams();

camL = webcam(2);
camR = webcam(3);

startLiveVid();
%    location = ADLocationPerTimestep(frames, params, temporalData);

function startLiveRun()
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~KEY_IS_PRESSED
      drawnow
      frameL = snapshot(camL);
      frameR = snapshot(camR);
	  stickLocation = ADLocationPerTimestep(frames, params);
	  [drumSound, drumState] = ADDecision(stickLoc, params, drumState);

end
disp('Run Finished! Hope you had a jolly good time')
end

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end