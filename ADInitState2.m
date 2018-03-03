function [lastLoc, kf] = ADInitState2(frames ,params, framesAreRectified)

% TODO asaf - change to inputParser?
if exist('framesAreRectified', 'var') && framesAreRectified
    stickLoc = ADLocationPerTimestep(frames, params, 'rectifyFrames', false);
else
    stickLoc = ADLocationPerTimestep(frames, params, 'displayAnaglyph', true);
end
for n = 1 : params.numOfSticks
    if stickLoc{n}.found == false
        lastLoc{n}.shift = 0;
        lastLoc{n}.x     = 0;
        lastLoc{n}.y     = 0;
        error('initialLocation was not found'); % TODO asaf - we do not want an error - we want loop until initialization
    else
        initialLocation = convertLocationToVec(stickLoc{n});
        kf{n} = configureKalmanFilter(params.kalman.motionModel, ...
          initialLocation, params.kalman.initialEstimateError, ...
          params.kalman.motionNoise, params.kalman.measurementNoise);

        correctedLocation = correct(kf{n}, initialLocation);

        % lastLoc{n}.shift = stickLoc{n}.shift;
        % lastLoc{n}.x     = stickLoc{n}.x;
        % lastLoc{n}.y     = stickLoc{n}.y;
        lastLoc{n} = convertVecToLocation(correctedLocation);
    end
    lastLoc{n}.found = true;
end
end