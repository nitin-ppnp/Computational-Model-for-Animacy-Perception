function [ FV4bar, pos] = L2( FV1f, FV1c,v1pos, properties )
% Performs the max pooling over the gabor filtered images.
% Inputs:
%    input 1 - Filtered output with fine resolution filtering
%    input 2 - Filtered output with coarse resolution filtering
%    input 3 - centers of the gabors receptive field
%    input 4 - properties object
% Outputs:
%    Output 1 - max pooled output
%    Output 2 - centers of the max pooling neurons
% 
% Author: Nitin Saini
% Last modified: 12/12/2017


timeSize = size(FV1f,4);
xgct = v1pos(1,:);
ygct = v1pos(2,:);


%         calculate the cell responses
for k = 1:timeSize       % iterate over time steps
   [FV4bar(:, :, :, k), xcv4, ycv4] =  V1mr2V4rb(squeeze(FV1f(:, :, :, k)), ...
                     squeeze(FV1c(:, :, :, k)),properties);
end
% centers of the max pooling neurons receptive fields
pos = [xcv4;ycv4]; 

thrV4b = properties.l2.threshold;         % threshold
nmfFV4bar = properties.l2.normFactor;         % fixed normalization factor
FV4bar = level(FV4bar, thrV4b, nmfFV4bar);

end

