function [dispParams] = CalcOfflineDispParams(params,frame)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% 
dispParams.numS         = params.numOfSticks;
dispParams.numD         = params.numOfDrums;
%dispParams.drumR        = params.drumR;
dispParams.colors       = {'k','b','y'};
dispParams.offset       = 100;

%% Calculate image bounds
thZ                 = 10;
[Ybound,Xbound, ~]  = size(frame); 
medShift            = params.drums{2}.shift;
Zbounds             = [max(medShift - thZ,0) medShift + thZ];
dispParams.bounds   = [1 Xbound 1 Ybound Zbounds];

end

