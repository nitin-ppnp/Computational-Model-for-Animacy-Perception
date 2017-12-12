function [ FV4bar, pos] = L2( FV1f, FV1c,v1pos, properties )
% Performs the max pooling over the gabor filtered images.
% Author: Nitin Saini
% Last modified: 12/12/2017


timeSize = size(FV1f,4);
xgct = v1pos(1,:);
ygct = v1pos(2,:);

%         CREATE THE V4 RESPONSES (BAR DETECTORS)

%         calculate the cell responses
for k = 1:timeSize       % iterate over time steps
   [FV4bar(:, :, :, k), xcv4, ycv4] =  V1mr2V4rb(squeeze(FV1f(:, :, :, k)), ...
                     squeeze(FV1c(:, :, :, k)),properties);
end

pos = [xcv4;ycv4]; 

thrV4b = properties.l2.threshold;         % threshold
nmfFV4bar = properties.l2.normFactor;         % fixed normalization factor
FV4bar = level(FV4bar, thrV4b, nmfFV4bar);

end

