function [offlineData] = ADInitOfflineData(offlineData)
% function for initialization of the offlineData struct

offlineStruct = struct('frameNum',{},'found',{},'x',{},'y',{},'shift',{},'angle',{},'radius',{},'sound',{},'frame',{});
offlineData{1} = offlineStruct;
offlineData{2} = offlineStruct;
end
