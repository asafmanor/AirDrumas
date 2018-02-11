function [drumSound, lastLocUpdate] = ADDecision3(stickLoc, params, lastLoc)

N = params.numOfSticks;
drums = params.drums;
drumSound = [9 9];
player = params.playerPosition;
minAngle = params.minAngle;
maxAngle = params.maxAngle;
totAngle = maxAngle - minAngle;
numOfDrums = params.numOfDrums;

for n = 1:N
    if stickLoc{n}.found && lastLoc{n}.found
        locInPlayerCoordinates = [stickLoc{n}.x - player(1),  stickLoc{n}.y - player(2)];
        Angle = findAngle(locInPlayerCoordinates, [1 0]); % angle of stick location with reference to X axis
        vprintf('high', 'stick #%d: x=%3.3f, y=%3.3f, shift=%3.3f , Angle = %3.3f\n',...
            n, stickLoc{n}.x, stickLoc{n}.y, stickLoc{n}.shift, Angle);
        for k = 1 : numOfDrums
            if (stickLoc{n}.shift <= drums{k}.shift && lastLoc{n}.shift > drums{k}.shift &&...
                    Angle >= (minAngle + (k-1)*totAngle/numOfDrums) && Angle < (minAngle + (k)*totAngle/numOfDrums))
                drumSound(n) = k;
            end
        end
    end
    lastLoc{n} = stickLoc{n};
end
lastLocUpdate = lastLoc;