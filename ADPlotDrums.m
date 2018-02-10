function ADPlotDrums(fig,params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for drumInd = 1:params.numOfDrums
    centers(drumInd,:) = [params.drums{drumInd}.x params.drums{drumInd}.y params.drums{drumInd}.shift];
    radii(drumInd) = params.drumR;
end

fig = viscircles(centers(:,[1 2]),radii);

end

