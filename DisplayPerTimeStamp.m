function DisplayPerTimeStamp(stickLoc,frame,dispParams)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Extract position from stickLoc and fix orientation
%frame = flipud(frame);
stickPos = nan(3,dispParams.numS);
if iscell(stickLoc)
    for stickInd = 1:dispParams.numS
        if stickLoc{stickInd}.found
            stickPos(:,stickInd) = [stickLoc{stickInd}.x stickLoc{stickInd}.y stickLoc{stickInd}.shift]';
        end
    end
else
    for stickInd = 1:dispParams.numS
        stickPos(:,stickInd) = stickLoc(:,:,stickInd)';
    end
end

%% Plot
figure(1);
%set(gcf, 'Position', get(0, 'Screensize'));

subplot(1,2,1);
for stickInd = [1:dispParams.numS]
    stem3(stickPos(1,stickInd),stickPos(2,stickInd),...
        stickPos(3,stickInd),dispParams.colors{stickInd});
    hold all;
    grid on;
    axis(dispParams.bounds);
    view(3);
    pbaspect([2 1 1]);
    set(gca,'Ydir','reverse')
    xlabel('X'); ylabel('Y'); zlabel('Z')
end
%title(['3D Tracking pos no.' num2str(posInd)]);
hold off;

subplot(1,2,2);
imshow(frame);
hold all;
for stickInd = [1:dispParams.numS]
    scatter(stickPos(1,stickInd),stickPos(2,stickInd),...
        'MarkerFaceColor',dispParams.colors{stickInd},'MarkerEdgeColor',dispParams.colors{stickInd});
    grid on;
    axis(dispParams.bounds(1:4));
    %title(['2D Tracking pos no.' num2str(posInd)]);
    xlabel('X'); ylabel('Y');
end
hold off;

end

