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
%     centers(drumInd,:) = [params.drums{drumInd}.x params.drums{drumInd}.y 1/params.drums{drumInd}.shift];
%     radii(drumInd) = params.drumR;
% end

drums = zeros(imSize);
drums = insertShape(drums,'FilledCircle',[centers(:,1) centers(:,2) radii]);
imagesc(drums);

% for drumInd = 1:params.numOfDrums
%     hold on;
%     fig = ADPlotDrum(fig,centers(drumInd,:),radii(drumInd),'red'); 
% end
% hold off;
% axis(imBounds);

end

