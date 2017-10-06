function  GABA = mkgaba(properties)
%MKGABA   returns a 3D array with 2D Gabor filters with multiple
%         different directions.

%
%                Version 0.0,  9 October 1999 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%


%         set default parameters

sag = properties.l1.gaborLen;          % length
sbg = properties.l1.gaborWidth;   % width
k0g = properties.l1.gaborWaveNum; % wave number

phgab = 0:7;            % angles

%% Martin's gabor

phgab = phgab / length(phgab) * pi;

GABA = mkgabf(phgab, [sag, sbg], k0g);

%% Serre's gabor
% 
% [~,G,~,~] = init_gabor(phgab*180/8,21,3.6); 
% for i=1:size(G,2)
%     GABA(:,:,i) = reshape(G(:,i),[21,21]);
% end




