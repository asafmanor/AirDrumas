function [drumSound, lastLocUpdate, params] = ADDecision3(stickLoc, params, lastLoc, offlineData) 

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
        if stickLoc{n}.found >= lastLoc{n}.found + params.marginOpenLock 
            params.lockOfStick{n} = 0;
        end
      end
        if params.offline.flag
           offlineData{n}.serialNum = offlineData{n}.serialNum + 1;
           num = offlineData{n}.serialNum;
           % offlineStruct is: ('num',{},'x',{},'y',{},'shift',{},'angle',{},'radius',{},'sound',{})
           offlineData{num}(1).frameNum = count;
           offlineData{num}(1).found = stickLoc{n}.found;
           offlineData{num}(1).x = stickLoc{n}.x;
           offlineData{num}(1).y = stickLoc{n}.y;
           offlineData{num}(1).shift = stickLoc{n}.shift;
           offlineData{num}(1).angle = Angle;
           offlineData{num}(1).radius = Radius;
           offlineData{num}(1).sound = drumSound(n);
        end
      lastLoc{n} = stickLoc{n};
    end
end
lastLocUpdate = lastLoc;