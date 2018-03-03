function [loc] = convertVecToLocation(vec)
	loc.x = vec(1);
	loc.y = vec(2);
	if numel(vec) == 3
		loc.shift = vec(3);
	end
end