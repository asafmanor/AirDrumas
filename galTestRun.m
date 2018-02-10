clear all; close all; 

sticLoc1 = [1:0.1:10; 1:0.1:10; 1:0.1:10]';
sticLoc2 = [10:-0.1:1; 10:-0.1:1; 10:-0.1:1]';

figure;
for i = 1:size(sticLoc1,1)
    ADPlotTrails(sticLoc1(i,:),sticLoc2(i,:));
    pause(0.1);
end