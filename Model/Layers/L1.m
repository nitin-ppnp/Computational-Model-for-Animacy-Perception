function [ FV1f, FV1c, pos ] = L1( PXM, properties )
%L1 Summary of this function goes here
%   Detailed explanation goes here

timeSize = size(PXM, 3);
% create the Gabor function array
GABA = mkgaba(properties);


for k = 1:timeSize
   [FV1f(:, :, :, k), FV1c(:, :, :, k),  xgct, ygct] = cgabmul(squeeze(PXM(:, :, k)), GABA,properties);
end

pos = [xgct;ygct];

%         rectify, normalize and threshold
thrFV1f = properties.l1.threshold;        % threshold
nmfFV1f = properties.l1.normFactor;        % fixed normalization factor
thrFV1c = properties.l1.threshold;        % threshold   
nmfFV1c = properties.l1.normFactor;        % fixed normalization factor
FV1f = level(FV1f, thrFV1f, nmfFV1f);
FV1c = level(FV1c, thrFV1c, nmfFV1c);



end

