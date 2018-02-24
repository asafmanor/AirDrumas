function [crop, x1, y1] = cropForLAB(frame, cropCenter, params)
% return the crop image of the cell defined by the cell's COM in size [params.crop.cropSize]
% INPUTS:	frame - image
%           params - parameters struct for the TDG
%           cropCenter - crop around this index  
% OUTPUTS: 	crop - crop greyscale image size [params.crop.cropSize] 
%           x1 - shift in x
% 			y1 - shift in y

h  = params.xy.cropSize(1);
w  = params.xy.cropSize(2);
y1 = max(round(cropCenter(1)-h/2),1);
y2 = min(round(cropCenter(1)+h/2),size(frame,1));
x1 = max(round(cropCenter(2)-w/2),1);
x2 = min(round(cropCenter(2)+w/2),size(frame,2));
crop = frame(y1:y2, x1:x2, :);

end