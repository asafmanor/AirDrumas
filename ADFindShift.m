function [newStickLoc] = ADFindShift(stickLoc, params)
N = params.numOfSticks;
for n = 1:N
	stickLoc{1}{n}.shift = abs(stickLoc{1}{n}.x-stickLoc{2}{n}.x);
    newStickLoc = stickLoc{1};
end

end