function ADPlotTrails(stickLoc,params)
%This function plots the 3D trails of the Blue and Red sticks. 
%trailR and trailB are arrays containing the last trailLen locations.
%The function uses locR and locB to update trailR and trailB respectively
%and plots them.

%Inputs - locR and LocB are 3D coordinates in the form of [X,Y,Z].

%% params defeintions
persistent trails
if isempty(trails)
    trails = {[],[]};
end
trailLen    = 3;
alphaValues = linspace(1,0,trailLen)'; %for transparency
imBounds = [1 1280 1 720]*params.pp.resize.resizeFactor;
colors = {'r', 'b'};

%% update trails
for stickInd = 1:params.numOfSticks
    if stickLoc{stickInd}.found
        loc = [stickLoc{stickInd}.x stickLoc{stickInd}.y stickLoc{stickInd}.shift];
        if size(trails{stickInd},1) < trailLen
            trails{stickInd} = cat(1, trails{stickInd}, nan(trailLen - size(trails{stickInd},1), 3));
        else
            trails{stickInd} = circshift(trails{stickInd},1,1);
        end
        % if size(trailB,1) < trailLen
        %     trailB = cat(1, trailB, nan(trailLen - size(trailB,1), 3));
        % else
        %     trailB = circshift(trailB,1,1);
        % end
        trails{stickInd}(1,:) = loc;
        % trailB(1,:) = locB;
    end
end

%% Plot trails
for alphaInd = 1:length(alphaValues)
    for stickInd = 1:params.numOfSticks
        scatter3(trails{stickInd}(alphaInd,1),trails{stickInd}(alphaInd,2),trails{stickInd}(alphaInd,3),...
            'MarkerFaceColor',colors{stickInd},'MarkerEdgeColor',colors{stickInd},'MarkerFaceAlpha'...
            ,alphaValues(alphaInd),'MarkerEdgeAlpha',alphaValues(alphaInd));
        hold all;
        grid on;
        axis([imBounds 0 10])
    end
    %     scatter3(trailB(alphaInd,1),trailB(alphaInd,2),trailB(alphaInd,3),'MarkerFaceColor','b','MarkerEdgeColor','b',...
    %         'MarkerFaceAlpha',alphaValues(alphaInd),'MarkerEdgeAlpha',alphaValues(alphaInd));
end
hold off;
end

