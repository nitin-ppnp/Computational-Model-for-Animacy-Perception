function  [FV1f, FV1c,  xgct, ygct] = cgabmul(PXM, GABA, properties)
%[FV1f, FV1c,  xgct, ygct] = 
%         cgabmul(PXM, GABA, xc, yc);
%         returns an array of responses of the Gabor filters
%         specified in the array GABA with centers that are ordered
%         in a grid that is given by the vectors xc and yc.

%
%                Version 0.0,  29 January 2000 by Martin Giese.
%
%                Tested with MATLAB 5.3 on a Pentium II under W98
%


szPXM = size(PXM);
szGABA = size(GABA);
diarf = (szGABA(1) -1) / 2;

% transform to single precision
%GABA = single(GABA);
%PXM = single(PXM);


%                define the centers of the Gabor filters
%xgct = 50:8:140;         
%ygct = 20:8:220;
%xgct = 20:8:120;         
%ygct = 10:8:200;%original filter positions
%xgct = 10:8:170;%original filter positions
% ygct = 46:36:900; %%filter positions for 900x900 walker
% xgct = 46:36:900; %%filter positions for 900x900 walker

ygct = properties.l1.ygct;    %%filter positions for 500x500 animacy display
xgct = properties.l1.xgct;    %%filter positions for 500x500 animacy display

[xgabc, ygabc] = meshgrid(xgct, ygct);




%                FINE RESOLUTION

%                calculate the Gabor filter output for 
%                the part of the RF that is overlapping 
%                with the pixelmap                   
% disp('Calculating Gabor cell respose.')
for l = 1:szGABA(3)
   for m = 1:length(xgct)
      for r = 1:length(ygct)
         indexx = xgct(m) - diarf : ...
            xgct(m) + diarf;
         indexy = ygct(r) - diarf : ...
                  ygct(r) + diarf;
         ivx = find(indexx > 0 & indexx <= szPXM(2));
         ivy = find(indexy > 0 & indexy <= szPXM(1));
         pwp = times(GABA(ivy, ivx, l),  PXM(indexy(ivy), ...
               indexx(ivx)));
         FV1f(r, m, l) = sum((pwp(:)));
      end
   end
end

%                COARSE RESOLUTION


%                subsample the image
szPXM = size(PXM);
subsiy = 1:2:szPXM(1);
subsix = 1:2:szPXM(2);
PXMc = PXM(subsiy, subsix);
xgctc = round(xgct / 2);
ygctc = round(ygct / 2);
 

%                calculate the Gabor filter output for 
%                the part of the RF that is overlapping 
%                with the pixelmap                   
% disp('Calculating Gabor cell respose.')
for m = 1:length(xgctc)
   for r = 1:length(ygctc)
      for l = 1:szGABA(3)
         indexx = (xgctc(m) - diarf) : (xgctc(m) + diarf);
         indexy = ygctc(r) - diarf : ...
                  ygctc(r) + diarf;
         ivx = find(indexx > 0 & indexx <= length(subsix));
         ivy = find(indexy > 0 & indexy <= length(subsiy));
         pwp = times(GABA(ivy, ivx, l),  PXMc(indexy(ivy), indexx(ivx)));
         FV1c(r, m, l) = sum((pwp(:)));
      end
   end
end


             
   
