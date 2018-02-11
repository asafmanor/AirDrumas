function [drumSound, lastLocUpdate, params] = ADDecision3(stickLoc, params, lastLoc) 

global offlineData

N = params.numOfSticks;
drums = params.drums;
drumSound = [9 9];
player = params.playerPosition;
minAngle = params.minAngle;
maxAngle = params.maxAngle;
totAngle = maxAngle - minAngle;
numOfDrums = params.numOfDrums;

% increase counter
if params.offline.flag
    params.offline.frameNum = params.offline.frameNum + 1;
end
count = params.offline.frameNum;

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
            drumSound(n) = k;
            params.lockOfStick{n} = 1;
          end
        end
        if stickLoc{n}.shift >= lastLoc{n}.shift + params.marginOpenLock 
            params.lockOfStick{n} = 0;
        end
      end
        if params.offline.flag
           num = params.offline.frameNum;
           % offlineStruct is: ('num',{},'x',{},'y',{},'shift',{},'angle',{},'radius',{},'sound',{})
           offlineData{n}(num).frameNum = count;
           offlineData{n}(num).found = stickLoc{n}.found;
           offlineData{n}(num).x = stickLoc{n}.x;
           offlineData{n}(num).y = stickLoc{n}.y;
           offlineData{n}(num).shift = stickLoc{n}.shift;
           offlineData{n}(num).angle = Angle;
           offlineData{n}(num).radius = Radius;
           offlineData{n}(num).sound = drumSound(n);
        end
      lastLoc{n} = stickLoc{n};
    end
end
lastLocUpdate = lastLoc;