function [ l4Resp ] = L4( v4resp,v4pos ,properties )
% Performs the preprocessing for the RBF network. Arrange the pooling
% output in the cells accoring to the receptive field of the object
% identifying cells (RBF network).
% Author: Nitin Saini
% Last modified: 12/12/2017

xv4ct = v4pos(1,:);
yv4ct = v4pos(2,:);
fSize = properties.l3.fSize;
fDist = properties.l3.fDist;
fDim = size(v4resp);

xstart= 1:fDist:fDim(2)-fSize+1;
ystart = 1:fDist:fDim(1)-fSize+1;

nRecField = length(xstart);
l4Resp = cell(nRecField,nRecField);

for i = 1:length(xstart)
    for j=1:length(ystart)
        idxx = xstart(i):xstart(i)+fSize-1;
        idxy = ystart(j):ystart(j)+fSize-1;
        l4Resp{i,j} = v4resp(idxx,idxy,:,:);
    end
end

end

