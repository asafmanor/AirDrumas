function [newStickLoc] = ADFindShift(stickLoc, sticksFound)
for n = 1:length(sticksFound)
    if sticksFound(n) == 1
        stickLoc{1}{n}.shift = abs(stickLoc{1}{n}.x-stickLoc{2}{n}.x);
        stickLoc{1}{n}.found = true;
    else
        stickLoc{1}{n}.found = false;
    end
end
newStickLoc = stickLoc{1};
end