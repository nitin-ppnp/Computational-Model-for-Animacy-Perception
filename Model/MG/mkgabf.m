function  GABA = mkgabf(ph, sig, kw, xc, yc)
%MKGABF(ph, sig, kw)
%         makes an array with Gabor filteres with the directions
%         given by the vector ph and yc and center (0, 0). 
%         sig is a vector that specifies the width and 
%         height of the gabor functions, and kw defines 
%         the wave number.
%         

%
%                Version 0.0,  9 October 1999 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%


%         create array of sampling points if not specified
if nargin < 4
          index = -round(2*max(sig)) : round(2 * max(sig));
          [Xgab, Ygab] = meshgrid(index, index(:));
       else
          [Xgab, Ygab] = meshgrid(xc, yc);
end
szgab = size(Xgab);

GABA = zeros(szgab(1), szgab(2), length(ph));
for k = 1:length(ph)
           phtmp = ph(k) + pi /2;
           Gtmp = (cos(phtmp)^2 / sig(1)^2 + sin(phtmp)^2 / sig(2)^2) ...
                    * Xgab.^2;
           Gtmp = 2 * (1 / sig(1)^2 - 1 / sig(2)^2) * cos(phtmp) * sin(phtmp) ...
                    * Xgab .* Ygab + Gtmp;
           Gtmp = (sin(phtmp)^2 / sig(1)^2 + cos(phtmp)^2 / sig(2)^2) ...
                    * Ygab.^2 + Gtmp;
           Gtmp = exp(-Gtmp / 2);
           Gtmp = Gtmp .* cos(kw * (sin(phtmp) * Xgab + ...
                                     cos(phtmp) * Ygab));
           GABA(:, :, k) = Gtmp;
           GABA(:,:,k) = GABA(:,:,k)-mean(mean(GABA(:,:,k)));
end
