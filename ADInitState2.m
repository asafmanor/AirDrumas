function [lastLoc] = ADInitState2(frames ,params)

stickLoc = ADLocationPerTimestep(frames, params, params.displayAnaglyph, []);

for n = 1 : params.numOfSticks
    if stickLoc{n}.found == false
        lastLoc{n}.shift = 0;
        lastLoc{n}.x     = 0;
        lastLoc{n}.y     = 0;
    else
        lastLoc{n}.shift = stickLoc{n}.shift;
        lastLoc{n}.x     = stickLoc{n}.x;
        lastLoc{n}.y     = stickLoc{n}.y;
    end
    lastLoc{n}.found = true;
end
end