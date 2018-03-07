function [vec] = convertLocationToVec(loc)
    vec = [loc.x, loc.y, loc.shift];
end