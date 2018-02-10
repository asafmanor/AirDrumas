function [newStickLoc] = ADFindShift(stickLoc, numOfSticksFound)
for n = 1:numOfSticksFound
	stickLoc{1}{n}.shift = abs(stickLoc{1}{n}.x-stickLoc{2}{n}.x);
    newStickLoc = stickLoc{1};
end
end