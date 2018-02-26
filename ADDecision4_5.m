function [drumSound, lastLocUpdate, params] = ADDecision4_5(stickLoc, params, lastLoc) 

N = params.numOfSticks;
drumsYLine=params.drumsYLine;
drums = params.drums;
drumSound = [9 9];
player = params.playerPosition;
minAngle = params.minAngle;
maxAngle = params.maxAngle;
totAngle = maxAngle - minAngle;
numOfDrums = params.numOfDrums;

clc
for n = 1:N
    if stickLoc{n}.found
        locInPlayerCoordinates = [stickLoc{n}.x - player(1),  stickLoc{n}.y - player(2)];
        Angle = findAngle(locInPlayerCoordinates, [1 0]); % angle of stick location with reference to X axis
        Radius = norm(locInPlayerCoordinates(1));
      if lastLoc{n}.found
        fprintf('stick #%d: x=%3.3f, y=%3.3f, shift=%3.3f , Angle = %3.3f, Radius = %3.3f\n\n',...
          n, stickLoc{n}.x, stickLoc{n}.y, stickLoc{n}.shift, Angle, Radius);
        for k = 1 : numOfDrums
          if (stickLoc{n}.shift + params.marginHit <=  lastLoc{n}.shift  && params.lockOfStick{n} == 0 && ...
            Angle >= (minAngle + (k-1)*totAngle/numOfDrums) && Angle < (minAngle + (k)*totAngle/numOfDrums))
            if stickLoc{n}.y>drumsYLine  && k~=1
                drumSound(n) = k+2;
            else
                drumSound(n) = k;
            end
            params.lockOfStick{n} = 1;
          end
        end
        if stickLoc{n}.shift >= lastLoc{n}.shift + params.marginOpenLock 
            params.lockOfStick{n} = 0;
        end
      end

      lastLoc{n} = stickLoc{n};
    end
end
lastLocUpdate = lastLoc;