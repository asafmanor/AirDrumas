function [lastLoc, kf] = ADInitState2(frames ,params, framesAreRectified)

N = params.numOfSticks;
% TODO asaf - change to inputParser?
if exist('framesAreRectified', 'var') && framesAreRectified
    stickLoc = ADLocationPerTimestep(frames, params, 'rectifyFrames', false);
else
    stickLoc = ADLocationPerTimestep(frames, params, 'displayAnaglyph', true);
end
lastLoc = cell(N,1);
kf = cell(N,1);
for n = 1 : N
    if stickLoc{n}.found == false
        lastLoc{n}.shift = 0;
        lastLoc{n}.x     = 0;
        lastLoc{n}.y     = 0;
        initialLocation = convertLocationToVec(lastLoc{n});
        kf{n} = configureKalmanFilter(params.kalman.motionModel, ...
          initialLocation, params.kalman.initialEstimateError, ...
          params.kalman.motionNoise, params.kalman.measurementNoise);
    else
        initialLocation = convertLocationToVec(stickLoc{n});
        kf{n} = configureKalmanFilter(params.kalman.motionModel, ...
          initialLocation, params.kalman.initialEstimateError, ...
          params.kalman.motionNoise, params.kalman.measurementNoise);

        correctedLocation = correct(kf{n}, initialLocation);
        lastLoc{n} = convertVecToLocation(correctedLocation);
    end
    lastLoc{n}.found = true;
end
end