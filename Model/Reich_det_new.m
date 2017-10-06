function [ resp, resp_v] = Reich_det_new(dirPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load([dirPath,'/','formresp.mat']);
tens = formresp.v4;
tens = permute(tens,[4,1,2,3]);
properties = formresp.properties;


fsize = properties.reich.fSize;
% fdist = properties.reich.fDist;
reich_xct = properties.reich.xct;
reich_yct = properties.reich.yct;


sz = size(tens);
frame_skp = 1;
sz_resp = [sz(1),sz(2),sz(3),3,12];
sz_resp(1) = floor(sz_resp(1)/frame_skp);
resp_v = zeros(sz_resp);   % Right now only for 3 velocities and 12 directions

% Filter
reich_filt = fspecial('gaussian',[fsize,fsize],0.1);
reich_filt = -reich_filt + 0.3;

% Another filter
filt = fspecial('gaussian',[fsize,fsize],0.3);
filt = -filt + 0.3;

% Combine filter
reich_filt = filter2(reich_filt,filt);

filt_tens = zeros(sz_resp(1),sz_resp(2),sz_resp(3));
marg_tens = zeros(size(filt_tens));


t = 1;
for i=1:frame_skp:sz(1)
    
    % Marginalization
    marg_tens(t,:,:) = marginalize(tens(i,:,:,:),4,'sum');
    %     temp_tens = squeeze(tens(i,:,:,:));
    %     [~,m] = max(temp_tens(:));
    %     [i1,i2,i3,i4] = ind2sub(size(tens),m);
    %     marg_tens(t,:,:) = squeeze(temp_tens(:,:,i4));
    
    
    
    % Filtering
    pad = squeeze(marg_tens(t,:,:));
    pad = padarray(pad,[(size(reich_filt,1)-1)/2,(size(reich_filt,1)-1)/2],'replicate');
    filt_tens(t,:,:) = filter2(reich_filt,pad,'valid');
    
    % Normalize
    temp_tens = filt_tens(t,:,:);
    mi = min(temp_tens(:));
    ma = max(temp_tens(:));
    filt_tens(t,:,:) = (temp_tens-mi)/(ma-mi);
    
    t = t+1;
end

maxvel = 6;
arstrt = maxvel+1;
arend = maxvel + size(filt_tens,2);
coo = [2,0;2,1;1,2;0,2;-1,2;-2,1;-2,0;-2,-1;-1,-2;0,-2;1,-2;2,-1]/2;
% coo = [4,0;4,1;4,2;4,3;4,4;3,4;2,4;1,4;0,4;-1,4;-2,4;-3,4;-4,4;-4,3;-4,2;-4,1;-4,0;-4,-1;-4,-2;-4,-3;-4,-4;-3,-4;-2,-4;-1,-4;0,-4;1,-4;2,-4;3,-4;4,-4;4,-3;4,-2;4,-1]/4;
filt_tens = padarray(filt_tens,[0,maxvel,maxvel]);
t = 1;
for i=2:size(filt_tens)
% % %     resp_v(t,1:end,:,1,1) = filt_tens(i,1:end,:).*filt_tens(i+1,1:end,:) - filt_tens(i+1,1:end,:).*filt_tens(i,1:end,:); % For zero vel
    % %         for j=1:3 % velocities are 0,1,2,3
    % %             % 0 degree
    % %             resp_v(t,1:end-j,:,j+1,1) = filt_tens(i,1:end-j,:).*filt_tens(i+1,j+1:end,:) - filt_tens(i+1,1:end-j,:).*filt_tens(i,j+1:end,:);
    % %             % 45 degree
    % %             resp_v(t,1:end-j,1:end-j,j+1,2) = filt_tens(i,1:end-j,1:end-j).*filt_tens(i+1,j+1:end,j+1:end) - filt_tens(i+1,1:end-j,1:end-j).*filt_tens(i,j+1:end,j+1:end);
    % %             % 90 degree
    % %             resp_v(t,:,1:end-j,j+1,3) = filt_tens(i,:,1:end-j).*filt_tens(i+1,:,j+1:end) -  filt_tens(i+1,:,1:end-j).*filt_tens(i,:,j+1:end);
    % %             % 135 degree
    % %             resp_v(t,j+1:end,1:end-j,j+1,4) = filt_tens(i,j+1:end,1:end-j).*filt_tens(i+1,1:end-j,j+1:end) - filt_tens(i+1,j+1:end,1:end-j).*filt_tens(i,1:end-j,j+1:end);
    % %             % 180 degree
    % %             resp_v(t,j+1:end,:,j+1,5) = filt_tens(i,j+1:end,:).*filt_tens(i+1,1:end-j,:) - filt_tens(i+1,j+1:end,:).*filt_tens(i,1:end-j,:);
    % %             % 225 degree
    % %             resp_v(t,j+1:end,j+1:end,j+1,6) = filt_tens(i,j+1:end,j+1:end).*filt_tens(i+1,1:end-j,1:end-j) - filt_tens(i+1,j+1:end,j+1:end).*filt_tens(i,1:end-j,1:end-j);
    % %             % 270 degree
    % %             resp_v(t,:,j+1:end,j+1,7) = filt_tens(i,:,j+1:end).*filt_tens(i+1,:,j+1:end) - filt_tens(i+1,:,j+1:end).*filt_tens(i,:,j+1:end);
    % %             % 315 degree
    % %             resp_v(t,1:end-j,j+1:end,j+1,8) = filt_tens(i,1:end-j,j+1:end).*filt_tens(i+1,j+1:end,1:end-j) - filt_tens(i+1,1:end-j,j+1:end).*filt_tens(i,j+1:end,1:end-j);
    % %         end
    for j=2:2:6 % velocities are 0,2,4,6
        for k=1:12
            resp_v(t,:,:,j/2,k) = filt_tens(i-1,arstrt:arend,arstrt:arend).*filt_tens(i,arstrt+j*coo(k,1):arend+j*coo(k,1),arstrt+j*coo(k,2):arend+j*coo(k,2)) - filt_tens(i,arstrt:arend,arstrt:arend).*filt_tens(i-1,arstrt+j*coo(k,1):arend+j*coo(k,1),arstrt+j*coo(k,2):arend+j*coo(k,2));
        end
    end
    t = t+1;
end
% % % Normalize
% % mi = min(resp_v(:));
% % ma = max(resp_v(:));
% % resp_v = (resp_v-mi)/(ma-mi);

fSize = properties.l3.fSize;
fDist = properties.l3.fDist;
fDim = size(resp_v);

xstart= 1:fDist:fDim(2)-fSize+1;
ystart = 1:fDist:fDim(3)-fSize+1;

resp = zeros(fDim(1),length(xstart),length(ystart),fDim(4),fDim(5));

for i = 1:length(xstart)
    for j=1:length(ystart)
        idxx = xstart(i):xstart(i)+fSize-1;
        idxy = ystart(j):ystart(j)+fSize-1;
        resp(:,i,j,:,:) = sum(sum(resp_v(:,idxx,idxy,:,:),2),3);
    end
end


end

