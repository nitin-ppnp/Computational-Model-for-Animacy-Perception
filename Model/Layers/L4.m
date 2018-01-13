function [ l4Resp ] = L4( v4resp,v4pos ,properties )
% Performs the preprocessing for the RBF network. Arrange the pooling
% output in the cells accoring to the receptive field of the object
% identifying cells (RBF network).
% Inputs:
%    input 1 - max pooled output
%    input 2 - centers of the max pooling neurons
%    input 3 - properties object
% Outputs:
%    Output 1 - The processed output to feed to the rbf network. Each cell
%    contains the data for each rbf neuron.
% 
% Author: Nitin Saini
% Last modified: 12/12/2017

% get the positions of the rbf neurons
xv4ct = v4pos(1,:);
yv4ct = v4pos(2,:);

% get the receptive field size and distance between them
fSize = properties.l3.fSize;
fDist = properties.l3.fDist;
fDim = size(v4resp);

% start coordinates of each rbf neuron
xstart= 1:fDist:fDim(2)-fSize+1;
ystart = 1:fDist:fDim(1)-fSize+1;

% number of rebf neurons
nRecField = length(xstart);
l4Resp = cell(nRecField,nRecField);

% get the processed data from previous layer and arrange in the cells to feed to the rbf network 
for i = 1:length(xstart)
    for j=1:length(ystart)
        idxx = xstart(i):xstart(i)+fSize-1;
        idxy = ystart(j):ystart(j)+fSize-1;
        l4Resp{i,j} = v4resp(idxx,idxy,:,:);
    end
end

end

