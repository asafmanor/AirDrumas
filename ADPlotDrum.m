function [fig] = ADPlotDrum(fig,center,radius,color)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
res = 100;
theta = linspace(0,2*pi,res);
rho = ones(1,res)*radius;
[x,y] = pol2cart(theta,rho);
x = center(1) + x;
y = center(2) + y;
fig = fill(x,y,color);
end

