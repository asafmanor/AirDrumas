function [offlineData] = ADInitOfflineData(offlineData)
% function description
% INPUTS: 	parameter1 -
%			parameter2 - 
% OUTPUTS: 	result - 

offlineStruct = struct('serialNum',0,'frameNum',{},'found',{},'x',{},'y',{},'shift',{},'angle',{},'radius',{},'sound',{});
offlineData{1} = offlineStruct;
offlineData{2} = offlineStruct;
end
