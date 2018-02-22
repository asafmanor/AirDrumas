function [dispParams,frames,stickPos] = ADCalcDisplayParams(offlineData,params)
%This function defines dafault parametrs to be used when displaying
%offlines results.
%inputs -   offlineData is a 2X1 cell of structs containing all recorded
%           data.
%           params is the paramas struct used when offlineData was recorded.
%outputs -  dispParams is a struct containing display paramters.
%           frames is a cell of frames diaplayed - currently using camera1.
%           stickPos is an Mx3xstickNum array of stickNum sticks positions.

%% Define default values
frames      = [];
stickPos    = [];

dispParams.numS         = length(offlineData);
dispParams.numD         = params.numOfDrums;
dispParams.drumR        = params.drumR;
dispParams.method       = 'tra';
dispParams.trLength     = 3;
dispParams.colors       = {'r','b','y'};
dispParams.fps          = 24;
dispParams.offset       = 100;

%% Create frames and stickPos arrays
for s = 1:dispParams.numS %stick loop
    for posInd = 1:length(offlineData{s}) %pos loop
        if offlineData{s}(posInd).found
            stickPos(posInd,:,s) = [offlineData{s}(posInd).x offlineData{s}(posInd).y offlineData{s}(posInd).shift];
        else
            stickPos(posInd,:,s) = nan(1,3);
        end
        frames{posInd} = offlineData{1}(posInd).frame;
    end %end pos loop
end %end stick loop
                    
%% Calculate image bounds
thZ     = 0.8;
Zvals   = squeeze(stickPos(:,3,:));
Zvals   = Zvals(~isnan(Zvals));
[Ybound,Xbound, ~]  = size(frames{1}); 
medZ                = median(Zvals);
Zbounds             = [max((1-thZ)*medZ,0) (1+thZ)*medZ];

dispParams.bounds   = [1 Xbound 1 Ybound Zbounds];

%% Fix orientation
for posInd = 1:length(offlineData{s}) %pos loop
    frames{posInd} = flipud(frames{posInd});
    for s = 1:dispParams.numS %stick loop
        stickPos(posInd,2,s) = Ybound - stickPos(posInd,2,s); 
    end
end

%% Define alphaValues for transperacy
dispParams.alphaValues = linspace(0,1,dispParams.trLength);

end

