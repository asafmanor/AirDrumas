function ADPlotTrails( location1, location2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

persistent trail1 trail2
trailLen        = 10;
alphaValues    = linspace(1,0,trailLen)'; 


%% update trails
if size(trail1,1) < trailLen
    trail1 = cat(1, trail1, zeros(trailLen - size(trail1,1), 3));
else
    trail1 = circshift(trail1,1,1); 
end
if size(trail2,1) < trailLen
    trail2 = cat(1, trail2, zeros(trailLen - size(trail2,1), 3));
else
    trail2 = circshift(trail2,1,1); 
end
trail1(1,:) = location1;
trail2(1,:) = location2;

%% Plot trails
hold all;
for alphaInd = 1:length(alphaValues)
    scatter3(trail1(alphaInd,1),trail1(alphaInd,2),trail1(alphaInd,3),'MarkerFaceColor','r','MarkerEdgeColor','r')
        %'MarkerFaceAlpha',alphaValues(alphaInd),'MarkerEdgeAlpha',alphaValues(alphaInd));
    grid on;
    axis([0 10 0 10 0 10])
    scatter3(trail2(alphaInd,1),trail2(alphaInd,2),trail2(alphaInd,3),'MarkerFaceColor','b','MarkerEdgeColor','b')
        %'MarkerFaceAlpha',alphaValues(alphaInd),'MarkerEdgeAlpha',alphaValues(alphaInd));
end
hold off;
end

