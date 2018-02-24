function [drumSound, lastLocUpdate] = ADDecision3_5(stickLoc, params, lastLoc)

N = params.numOfSticks;
drums = params.drums;
midy=params.y;
drumSound = [9 9];
player = params.playerPosition;
minAngle = params.minAngle;
maxAngle = params.maxAngle;
totAngle = maxAngle - minAngle;
numOfDrums = params.numOfDrums;

stickColor = {'Red', 'Blue'};
clc
for n = 1:N
    if stickLoc{n}.found && lastLoc{n}.found
        locInPlayerCoordinates = [stickLoc{n}.x - player(1),  stickLoc{n}.y - player(2)];
        Angle = findAngle(locInPlayerCoordinates, [1 0]); % angle of stick location with reference to X axis
        fprintf('%s stick: x=%3.3f, y=%3.3f, shift=%3.3f , Angle = %3.3f\n',...
            stickColor{n}, stickLoc{n}.x, stickLoc{n}.y, stickLoc{n}.shift, Angle);
        for k = 1 : numOfDrums
            % find correct region
            if (Angle >= (minAngle + (k-1)*totAngle/numOfDrums) && Angle < (minAngle + (k)*totAngle/numOfDrums))
                if (stickLoc{n}.shift <= drums{k}.shift && lastLoc{n}.shift > drums{k}.shift)
                    if  stickLoc{n}.y>midy && k~=1
                        drumSound(n) = k+2; 
                    else
                        drumSound(n) = k;
                    end
                end
                % update gauge
                if isfield(params, 'drumGauges')
                    updateValue(params.drumGauges, drums{k}.name, stickLoc{n}.shift-drums{k}.shift);
                end
            end
        end % end of for loop
    end % end of found 'if'
    lastLoc{n} = stickLoc{n};
end
lastLocUpdate = lastLoc;