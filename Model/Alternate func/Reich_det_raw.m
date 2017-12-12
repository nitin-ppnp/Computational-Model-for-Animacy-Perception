function [ resp ] = Reich_det_raw( dirPath )
%REICH_DET_RAW Summary of this function goes here
%   Detailed explanation goes here

PXM = loadPixelArray(dirPath);
maxvel = 40;

load([dirPath,'/','formresp.mat']);
properties = formresp.properties;

resp_v = zeros(size(PXM,3),size(PXM,1),size(PXM,2),maxvel/4,12);

% Reichardt detector cells 
arstrt = maxvel+1;
arend = maxvel + size(PXM,1);
PXM = padarray(PXM,[maxvel,maxvel,0]);
coo = [2,0;2,1;1,2;0,2;-1,2;-2,1;-2,0;-2,-1;-1,-2;0,-2;1,-2;2,-1]/2;
for i=2:size(PXM,3)
    for j=4:4:maxvel % velocities
        for k=1:12
            resp_v(i,:,:,j/4,k) = PXM(arstrt:arend,arstrt:arend,i-1).*PXM(arstrt+j*coo(k,1):arend+j*coo(k,1),arstrt+j*coo(k,2):arend+j*coo(k,2),i) - PXM(arstrt:arend,arstrt:arend,i).*PXM(arstrt+j*coo(k,1):arend+j*coo(k,1),arstrt+j*coo(k,2):arend+j*coo(k,2),i-1);
        end
    end
end
% % % Normalize
% % mi = min(resp_v(:));
% % ma = max(resp_v(:));
% % resp_v = (resp_v-mi)/(ma-mi);


% Complex cells to sum the simple cell response
s = size(properties.rfmap.l3);

resp = zeros(size(PXM,3),s(1),s(2),size(resp_v,4),size(resp_v,5));

for i = 1:s(1)
    for j=1:s(2)
        idxx = properties.rfmap.l3(j,i,1,1):properties.rfmap.l3(j,i,3,1);
        idxy = properties.rfmap.l3(j,i,1,2):properties.rfmap.l3(j,i,3,2);
        resp(:,i,j,:,:) = sum(sum(resp_v(:,idxx,idxy,:,:),2),3);
    end
end
end

