function [ FV1f, FV1c, pos ] = L1( PXM, properties )
% Performs the processing of the first layer of the formapathway (gabor
% filtering).
% Inputs:
%    input 1 - Grayscaled image array
%    input 2 - properties object  
% Outputs:
%    Output 1 - Filtered output with fine resolution filtering
%    Output 2 - Filtered output with coarse resolution filtering
%    Output 3 - centers of the gabors receptive field
% 
% Author: Nitin Saini
% Last modified: 12/12/2017

timeSize = size(PXM, 3);
% create the Gabor function array
GABA = mkgaba(properties);

% Gabor filtering
for k = 1:timeSize
   [FV1f(:, :, :, k), FV1c(:, :, :, k),  xgct, ygct] = cgabmul(squeeze(PXM(:, :, k)), GABA,properties);
end

% centers of the gabor receptive fields
pos = [xgct;ygct];

%         rectify, normalize and threshold
thrFV1f = properties.l1.threshold;        % threshold
nmfFV1f = properties.l1.normFactor;        % fixed normalization factor
thrFV1c = properties.l1.threshold;        % threshold   
nmfFV1c = properties.l1.normFactor;        % fixed normalization factor
FV1f = level(FV1f, thrFV1f, nmfFV1f);
FV1c = level(FV1c, thrFV1c, nmfFV1c);



end

