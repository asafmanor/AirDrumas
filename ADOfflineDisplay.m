function ADOfflineDisplay(stickPos,frames,dispParams)
%This function displays the offline data in frames and stickPos using
%dispParams.

figure;
set(gcf, 'Position', get(0, 'Screensize'));

% main loop
for posInd = 1 + dispParams.offset:size(stickPos,1) - dispParams.trLength
    subplot(1,2,1);
    switch dispParams.method
        case 'trails'
            for alphaInd = 1:length(dispParams.alphaValues)
                for stickInd = [1:size(stickPos,3)]
                    scatter3(stickPos(posInd + alphaInd - 1,1,stickInd),stickPos(posInd + alphaInd - 1,2,stickInd),...
                        stickPos(posInd + alphaInd - 1,3,stickInd),...
                        'MarkerFaceColor',dispParams.colors{stickInd},'MarkerEdgeColor',dispParams.colors{stickInd},'MarkerFaceAlpha',...
                        dispParams.alphaValues(alphaInd),'MarkerEdgeAlpha',dispParams.alphaValues(alphaInd));
                    hold all;
                    grid on;
                    axis(dispParams.bounds);
                    view(3);
                    pbaspect([2 1 1]);
                    set(gca,'Ydir','reverse')
                    xlabel('X'); ylabel('Y'); zlabel('Z')
                end
            end
        case 'stem'
            for stickInd = [1:size(stickPos,3)]
                stem3(stickPos(posInd,1,stickInd),stickPos(posInd,2,stickInd),...
                    stickPos(posInd,3,stickInd),dispParams.colors{stickInd});
                hold all;
                grid on;
                axis(dispParams.bounds);
                view(3);
                pbaspect([2 1 1]);
                set(gca,'Ydir','reverse')
                xlabel('X'); ylabel('Y'); zlabel('Z')
            end
    end
    title(['3D Tracking pos no.' num2str(posInd)]);
    hold off;
    
    subplot(1,2,2);
    imshow(frames{posInd});
    hold all;
    for stickInd = [1:size(stickPos,3)]
        scatter(stickPos(posInd,1,stickInd),stickPos(posInd,2,stickInd),...
            'MarkerFaceColor',dispParams.colors{stickInd},'MarkerEdgeColor',dispParams.colors{stickInd});
        grid on;
        axis(dispParams.bounds(1:4));
        title(['2D Tracking pos no.' num2str(posInd)]);
        xlabel('X'); ylabel('Y');
    end
    hold off;
    pause(1/dispParams.fps);

end %end main loop

end

