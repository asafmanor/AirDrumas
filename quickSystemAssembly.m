function params = quickSystemAssembly(params, camR, camL)
preview(camR);
preview(camL);
originalNumOfSticks = params.numOfSticks;
params.numOfSticks = 1;

input('quickSystemAssembly: please work with red stick');
for n = 1:params.numOfDrums
	fprintf('press any key when to save location of drum #%d', n);
    input('');
	frames{1} = snapshot(camR);
	frames{2} = snapshot(camL);
	stickLoc = ADLocationPerTimestep(frames, params);
	if stickLoc{1}.found == false
		error('stick was not found and system can not be assembled, you prick! exiting!!!');
	end
	params.drums{n}.x     = stickLoc{1}.x;
	params.drums{n}.y     = stickLoc{1}.y;
	params.drums{n}.shift = stickLoc{1}.shift;
end
params.numOfSticks = originalNumOfSticks;
disp('system assembly ended');
end