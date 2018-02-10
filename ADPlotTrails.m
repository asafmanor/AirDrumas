function ADPlotTrails(locR,locB)
%This function plots the 3D trails of the Blue and Red sticks. 
%trailR and trailB are arrays containing the last trailLen locations.
%The function uses locR and locB to update trailR and trailB respectively
%and plots them.

%Inputs - locR and LocB are 3D coordinates in the form of [X,Y,Z].

%% params defeintions
persistent trailR trailB
trailLen    = 10;
alphaValues = linspace(1,0,trailLen)'; %for transparency

%% update trails
if size(trailR,1) < trailLen
    trailR = cat(1, trailR, nan(trailLen - size(trailR,1), 3));
else
    trailR = circshift(trailR,1,1); 
end
if size(trailB,1) < trailLen
    trailB = cat(1, trailB, nan(trailLen - size(trailB,1), 3));
else
    trailB = circshift(trailB,1,1); 
end
trailR(1,:) = locR;
trailB(1,:) = locB;

%% Plot trails
for alphaInd = 1:length(alphaValues)
    scatter3(trailR(alphaInd,1),trailR(alphaInd,2),trailR(alphaInd,3),'MarkerFaceColor','r','MarkerEdgeColor','r',...
        'MarkerFaceAlpha',alphaValues(alphaInd),'MarkerEdgeAlpha',alphaValues(alphaInd));
    hold all;
    grid on;
    axis([0 10 0 10 0 10])
    scatter3(trailB(alphaInd,1),trailB(alphaInd,2),trailB(alphaInd,3),'MarkerFaceColor','b','MarkerEdgeColor','b',...
        'MarkerFaceAlpha',alphaValues(alphaInd),'MarkerEdgeAlpha',alphaValues(alphaInd));
end
hold off;
end

