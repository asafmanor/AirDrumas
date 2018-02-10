function ADPlotDrums(fig,params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
imSize  = [1280 720]*params.pp.resize.resizeFactor;
imBounds = [1 imSize(1) 1 imSize(2)];


centers = [20, 20, 70;
           60, 20, 65;
           100, 20, 65;
           20, 60, 66];
radii   = 30*ones(4,1)*params.pp.resize.resizeFactor;


% for drumInd = 1:params.numOfDrums
%     centers(drumInd,:) = [params.drums{drumInd}.x params.drums{drumInd}.y params.drums{drumInd}.shift];
%     radii(drumInd) = params.drumR;
% end

scatter(canters(1),);
fig = viscircles(centers(:,[1 2]),radii,'full');
axis(imBounds);

end

