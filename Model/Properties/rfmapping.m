function [  properties ] = rfmapping( properties )
%RFMAPPING Summary of this function goes here
%   Detailed explanation goes here

%% L1
v1size = [length(properties.l1.xgct),length(properties.l1.ygct)];
properties.rfmap.v1 = zeros(v1size(1),v1size(2),4,2);
v1_half_fsize = round(2*properties.l1.gaborLen);

x1 = properties.l1.xgct - v1_half_fsize;
[x1,~] = meshgrid(x1,properties.l1.ygct);
x2 = properties.l1.xgct + v1_half_fsize;
[x2,~] = meshgrid(x2,properties.l1.ygct);

y1 = properties.l1.ygct - v1_half_fsize;
[~,y1] = meshgrid(properties.l1.xgct,y1);
y2 = properties.l1.ygct + v1_half_fsize;
[~,y2] = meshgrid(properties.l1.xgct,y2);

properties.rfmap.v1(:,:,1,1) = x1;
properties.rfmap.v1(:,:,2,1) = x1;
properties.rfmap.v1(:,:,3,1) = x2;
properties.rfmap.v1(:,:,4,1) = x2;
properties.rfmap.v1(:,:,1,2) = y1;
properties.rfmap.v1(:,:,2,2) = y2;
properties.rfmap.v1(:,:,3,2) = y2;
properties.rfmap.v1(:,:,4,2) = y1;
properties.rfmap.v1xct = properties.l1.xgct;
properties.rfmap.v1yct = properties.l1.ygct;

%% L2

%   Get Centers first

xgct = properties.l1.xgct;
ygct = properties.l1.ygct;

nrfV4 =  properties.l2.numV4rf;


%         define V4 RF centers equally spaced between
%         the Gabor filters
dctx = (max(xgct) - min(xgct)) / nrfV4(1);
xcv4 = xgct(1) + (-0.5 + 1:nrfV4(1)) * dctx;
dcty = (max(ygct) - min(ygct)) / nrfV4(2);
ycv4 = ygct(1) + (-0.5 + 1:nrfV4(2)) * dcty;

v4xpos = zeros(length(xcv4),length(ycv4));
v4ypos = v4xpos;

%         create matrices with V1 positions
[V1cx, V1cy] = meshgrid(1:length(xgct), 1:length(ygct));
[xgabc, ygabc] = meshgrid(xgct, ygct);

for l = 1:length(xcv4)  %iterate over all RF centers
    for m = 1:length(ycv4)
        
        %   find closest V1 cell to RF center of the V4 cell
        index = (xgabc - xcv4(l)).^2 +  (ygabc - ycv4(m)).^2;
        index = find(index == min(index(:)));
        
        indV1x = V1cx(index(1));
        indV1y = V1cy(index(1));
        
        v4xpos(l,m) = indV1x;
        v4ypos(l,m) = indV1y;
        
    end
end
properties.l2.xct = v4xpos(:,1)';
properties.l2.yct = v4ypos(1,:);

% Get vertices

v4size = [length(properties.l2.xct),length(properties.l2.yct)];
properties.rfmap.v4 = zeros(v4size(1),v4size(2),4,2);
v4_half_fsize = (length(properties.l2.ngbVec)-1)/2;

%       Get mapping from l2 to l1
x1 = properties.l2.xct - v4_half_fsize;
x2 = properties.l2.xct + v4_half_fsize;
x1(x1<1) = 1;
x2(x2>length(properties.l1.xgct)) = length(properties.l1.xgct);
y1 = properties.l2.yct - v4_half_fsize;
y2 = properties.l2.yct + v4_half_fsize;
y1(y1<1) = 1;
y2(y2>length(properties.l1.ygct)) = length(properties.l1.ygct);

%       going from l1 to pixels
tempx1 = properties.rfmap.v1(x1,y1,1,1);
tempy1 = properties.rfmap.v1(x1,y1,1,2);
tempx2 = properties.rfmap.v1(x2,y2,3,1);
tempy2 = properties.rfmap.v1(x2,y2,3,2);

%       Assign pixels to RF
properties.rfmap.v4(:,:,1,1) = tempx1;
properties.rfmap.v4(:,:,2,1) = tempx1;
properties.rfmap.v4(:,:,3,1) = tempx2;
properties.rfmap.v4(:,:,4,1) = tempx2;
properties.rfmap.v4(:,:,1,2) = tempy1;
properties.rfmap.v4(:,:,2,2) = tempy2;
properties.rfmap.v4(:,:,3,2) = tempy2;
properties.rfmap.v4(:,:,4,2) = tempy1;

%       Get the centers
properties.rfmap.v4xct = properties.l1.xgct(properties.l2.xct);
properties.rfmap.v4yct = properties.l1.ygct(properties.l2.yct);


%% L3
properties.l3.xct = (properties.l3.fSize-1)/2+1:properties.l3.fDist:length(properties.l2.xct)-(properties.l3.fSize-1)/2;
properties.l3.yct = (properties.l3.fSize-1)/2+1:properties.l3.fDist:length(properties.l2.yct)-(properties.l3.fSize-1)/2;

% Get vertices

l3rfsize = [length(properties.l3.xct),length(properties.l3.yct)];
properties.rfmap.l3 = zeros(l3rfsize(1),l3rfsize(2),4,2);
l3_half_fsize = (properties.l3.fSize-1)/2;

%       Get mapping from l2 to l1
x1 = properties.l3.xct - l3_half_fsize;
x2 = properties.l3.xct + l3_half_fsize;
x1(x1<1) = 1;
x2(x2>length(properties.l2.xct)) = length(properties.l2.xct);
y1 = properties.l3.yct - l3_half_fsize;
y2 = properties.l3.yct + l3_half_fsize;
y1(y1<1) = 1;
y2(y2>length(properties.l2.yct)) = length(properties.l2.yct);

%       going from l1 to pixels
tempx1 = properties.rfmap.v4(x1,y1,1,1);
tempy1 = properties.rfmap.v4(x1,y1,1,2);
tempx2 = properties.rfmap.v4(x2,y2,3,1);
tempy2 = properties.rfmap.v4(x2,y2,3,2);

%       Assign pixels to RF
properties.rfmap.l3(:,:,1,1) = tempx1;
properties.rfmap.l3(:,:,2,1) = tempx1;
properties.rfmap.l3(:,:,3,1) = tempx2;
properties.rfmap.l3(:,:,4,1) = tempx2;
properties.rfmap.l3(:,:,1,2) = tempy1;
properties.rfmap.l3(:,:,2,2) = tempy2;
properties.rfmap.l3(:,:,3,2) = tempy2;
properties.rfmap.l3(:,:,4,2) = tempy1;

%       Get the centers
properties.rfmap.l3xct = properties.l1.xgct(properties.l2.xct(properties.l3.xct));
properties.rfmap.l3yct = properties.l1.ygct(properties.l2.yct(properties.l3.yct));


%% 

properties.reich.xct = (properties.reich.fSize-1)/2+1:properties.reich.fDist:length(properties.l3.xct)-(properties.reich.fSize-1)/2;
properties.reich.yct = (properties.reich.fSize-1)/2+1:properties.reich.fDist:length(properties.l3.yct)-(properties.reich.fSize-1)/2;
