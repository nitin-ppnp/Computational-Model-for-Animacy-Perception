function [ l4Resp ] = L4( v4resp,v4pos ,properties )
%FOURTHLAYER Summary of this function goes here
%   Detailed explanation goes here

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

% % % xv4ct = v4pos(1,:);
% % % yv4ct = v4pos(2,:);
% % % 
% % % szFV1 = size(v4resp);
% % % 
% % % %         set parameters
% % % %nrfV4 =  [3, 6];       %  spatial sampling of RF 
% % % %nrfV4 =  [6, 6];
% % % %ngb = [-1 : 1];        %  neigborhood vector
% % % %ngb = [-2 : 2];        %  neigborhood vector
% % % ngb = properties.l3.ngbVec;        %  neigborhood vector
% % % nrfV4 =  properties.l3.numV4rf;
% % % 
% % % %phbd = [0:szFV1(3)-1];
% % % %barlg = 3; 0.1;            %  length of the bars
% % % 
% % % %phbd = pi * phbd / length(phbd);
% % % %phgab = phbd;
% % % 
% % % 
% % % %         define V4 RF centers equally spaced between 
% % % %         the Gabor filters
% % % dctx = (max(xv4ct) - min(xv4ct)) / nrfV4(1);
% % % xcl3 = xv4ct(1) + (-0.5 + 1:nrfV4(1)) * dctx;
% % % dcty = (max(yv4ct) - min(yv4ct)) / nrfV4(2);
% % % ycl3 = yv4ct(1) + (-0.5 + 1:nrfV4(2)) * dcty;
% % % 
% % % 
% % % 
% % % %         create neighborhood vectors
% % % % [Xng, Yng] = meshgrid(ngb, ngb);
% % % % xnv = Xng(:);
% % % % ynv = Yng(:);
% % % 
% % % xnv = ngb;
% % % ynv = ngb;
% % % 
% % % %         create matrices with V1 positions
% % % [V1cx, V1cy] = meshgrid(1:length(xv4ct), 1:length(yv4ct));
% % % [xgabc, ygabc] = meshgrid(xv4ct, yv4ct);
% % % 
% % % l4Resp = cell(length(xcl3),length(ycl3));
% % % 
% % % %         calculate the cell response
% % % for l = 1:length(xcl3)  %iterate over all RF centers
% % %    for m = 1:length(ycl3)
% % %       
% % %          %   find closest V1 cell to RF center of the V4 cell
% % %          index = (xgabc - xcl3(l)).^2 +  (ygabc - ycl3(m)).^2;
% % %          index = find(index == min(index(:)));
% % %          indV1x = V1cx(index(1));
% % %          indV1y = V1cy(index(1));
% % % 
% % % 
% % %          %   find closest V1 orientation tuning
% % %          %phV1ind = cos(phgab - phbd(n));
% % %          %phV1ind = find(phV1ind == max(phV1ind));
% % %          %phV1ind = phV1ind(1);
% % % 
% % % 
% % %          %   get cell indices within the RF
% % %          xv_tmp = xnv + indV1x;
% % %          yv_tmp = ynv + indV1y;
% % %          indval = find(xv_tmp > 0 & xv_tmp <= length(xv4ct) ...
% % %                        & yv_tmp > 0 & yv_tmp <= length(yv4ct));
% % %          xv_tmp = xv_tmp(indval);
% % %          yv_tmp = yv_tmp(indval);
% % %          
% % %          l4Resp{l,m} = v4resp(xv_tmp,yv_tmp,:,:);
% % %         
% % %    end
% % % end

end

