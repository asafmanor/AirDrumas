clear all; close all; 
% %%
% sticLoc1 = [1:0.1:10; 1:0.1:10; 1:0.1:10]';
% sticLoc2 = [10:-0.1:1; 10:-0.1:1; 10:-0.1:1]';
% 
% figure;
% for i = 1:size(sticLoc1,1)
%     ADPlotTrails(sticLoc1(i,:),sticLoc2(i,:));
%     pause(0.1);
% end

%%
% params = ADLoadParams();
% fig = 1;
% 
% ADPlotDrums(fig,params);

%%
% t = -10*pi:pi/250:10*pi;
% x = (cos(2*t).^2).*sin(t);
% y = (sin(2*t).^2).*cos(t);
% comet3(x,y,t,0.01);
load(fullfile('Offline','offlineData.mat'));
clear offlineData;
%load('C:\Users\glifshitz\Documents\GitHub\AirDrums\Offline\record1.mat')
 load(fullfile('Offline','record2.mat'));

ADOfflineMode(offlineData,params);



