function  [FV4bar, v4xpos, v4ypos] = V1mr2V4rb(FV1f, FV1c,properties)
%[FV4bar, xcv4, ycv4] = V1r2V4rb(FV1f, FV1c, xgct, ygct);
%         transforms the responses FV1 of the V1 Gabor filter
%         on fine and coarsae scale of resolution (FV1f and FV1c)
%         into the responses of an array of spatially 
%         invariant V4 detectors. The additional input argument
%         vectors specify the center of the Gabor functions.
%         The additional output vectors specify the centers
%         of the bar detectors.
%        
 
%
%                Version 0.0,  9 October 1999 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%

szFV1 = size(FV1f);

ngb = properties.l2.ngbVec;        %  neigborhood vector

v4xpos = properties.l2.xct;
v4ypos = properties.l2.yct;
xgct = properties.l1.xgct;
ygct = properties.l1.ygct;

%         create neighborhood vectors
[Xng, Yng] = meshgrid(ngb, ngb);
xnv = Xng(:);
ynv = Yng(:);



%         calculate the cell response
for l = 1:length(v4xpos)  %iterate over all RF centers
   for m = 1:length(v4ypos)
         
         indV1x = v4xpos(l);
         indV1y = v4ypos(m);

         %   find closest V1 orientation tuning
         %phV1ind = cos(phgab - phbd(n));
         %phV1ind = find(phV1ind == max(phV1ind));
         %phV1ind = phV1ind(1);


         %   get cell indices within the RF
         xv_tmp = xnv + indV1x;
         yv_tmp = ynv + indV1y;
         indval = find(xv_tmp > 0 & xv_tmp <= length(xgct) ...
                       & yv_tmp > 0 & yv_tmp <= length(ygct));
         xv_tmp = xv_tmp(indval);
         yv_tmp = yv_tmp(indval);
        
         %   get maximum acivity over RF for each direction and scale
         for n = 1:szFV1(3)   % iterate over the directions
                 max_f = max(diag(FV1f(yv_tmp, xv_tmp, n)));
                 max_c = max(diag(FV1c(yv_tmp, xv_tmp, n)));
                 FV4bar(m, l, n) = max(max_f, max_c);
         end
   end
end
