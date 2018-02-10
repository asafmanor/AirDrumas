function [ThetaInDegrees] = findAngle(u,v)
CosTheta = dot(u,v)/(norm(u)*norm(v));
ThetaInDegrees = acosd(CosTheta);
end
