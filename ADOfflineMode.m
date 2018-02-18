function ADOfflineMode(offlineData,params)
%This function is the main function for analayzing recorded data offline.
%inputs -   offlineData is a 2X1 cell of structs containing all recorded
%           data.
%           params is the paramas struct used when offlineData was recorded.

%% Extract display params
[dispParams,frames,stickPos] = ADCalcDisplayParams(offlineData,params);

%% Display offline results
ADOfflineDisplay(stickPos,frames,dispParams);

end

