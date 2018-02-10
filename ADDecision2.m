function [drumSound, lastLocUpdate] = ADDecision2(stickLoc, params, lastLoc) 

N = params.numOfSticks;
drums = params.drums;
drumSound = [9 9];

for n = 1:N
  if stickLoc{n}.found && lastLoc{n}.found
    for k = 1:params.numOfDrums
      if norm([stickLoc{n}.x stickLoc{n}.y] - [drums{k}.x drums{k}.y]) <= params.drumR &&...
        stickLoc{n}.shift <= drums{k}.shift && lastLoc{n}.shift > drums{k}.shift
        drumSound(n) = k-1;
        break;
      end
    end
  end
  lastLoc{n} = stickLoc{n};
end
lastLocUpdate = lastLoc;