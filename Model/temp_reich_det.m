function [ resp_cart,resp,mcart,ncart] = Reich_det(dirPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load([dirPath,'/','formresp.mat']);
% tens = formresp.v1f;

PXM = loadPixelArray(dirPath);
tens(:,:,1,:) = PXM;
tens(:,:,2,:) = 0;

tens = permute(tens,[4,1,2,3]);
properties = formresp.properties;

fsize = properties.reich.fSize;
% fdist = properties.reich.fDist;
reich_xct = properties.reich.xct;
reich_yct = properties.reich.yct;


sz = size(tens);
frame_skp = 2;
sz_resp = [sz(1),sz(2),sz(3),3,12];
sz_resp(1) = floor(sz_resp(1)/frame_skp);
resp_v = zeros(sz_resp);   % Right now only for 3 velocities and 12 directions

% Filter
reich_filt = fspecial('gaussian',[fsize,fsize],20);
reich_filt = -reich_filt + 0.3;

% Another filter
filt = fspecial('gaussian',[fsize,fsize],20);
filt = filt - 0.3;

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
    
    
    %%%%%%%%%%%%
    marg_tens = movmean(marg_tens,25,2);
    marg_tens = movmean(marg_tens,25,3);
    %%%%%%%%%%%%
    
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

%%  Artificially fit gaussian to filt_tens
gauss_X = fspecial('gaussian',[500,1],2);
for i=1:size(filt_tens,1)
    t = squeeze(filt_tens(i,:,:));
    [~,j] = max(t(:));
    [x(i),y(i)] = ind2sub(size(t),j);
    gauss_x = circshift(gauss_X,[-250+x(i)-1,0]);
    gauss_y = circshift(gauss_X,[-250+y(i)-1,0]);
    filt_tens(i,:,:) = gauss_x*gauss_y';
end

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for i=1:size(tens,1)
% % t = squeeze(filt_tens(i,:,:));
% % [~,j] = max(t(:));
% % [q(i),w(i)] = ind2sub(size(t),j);
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% % maxvel = 6;
% % arstrt = maxvel+1;
% % arend = maxvel + size(filt_tens,2);
% % coo = [2,0;2,1;1,2;0,2;-1,2;-2,1;-2,0;-2,-1;-1,-2;0,-2;1,-2;2,-1]/2;
% % % coo = [4,0;4,1;4,2;4,3;4,4;3,4;2,4;1,4;0,4;-1,4;-2,4;-3,4;-4,4;-4,3;-4,2;-4,1;-4,0;-4,-1;-4,-2;-4,-3;-4,-4;-3,-4;-2,-4;-1,-4;0,-4;1,-4;2,-4;3,-4;4,-4;4,-3;4,-2;4,-1]/4;
% % filt_tens = padarray(filt_tens,[0,maxvel,maxvel]);
% % t = 1;

for i=2:size(filt_tens,1)
    a = squeeze(filt_tens(i-1,:,:));
    b = squeeze(filt_tens(i,:,:));
    temp = xcorr2(a,b);
    resp(i,:,:) = temp(300:700,300:700);
    t = squeeze(resp(i,:,:));
    [~,j] = max(t(:));
    [mresp(i),nresp(i)] = ind2sub(size(t),j);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=2:size(resp,1)
%     a = squeeze(resp(i-1,:,:));
%     b = squeeze(resp(i,:,:));
%     temp = xcorr2(a,b);
%     fresp(i,:,:) = temp(170:230,170:230);
%     t = squeeze(fresp(i,:,:));
%     [~,j] = max(t(:));
%     [m2(i),n2(i)] = ind2sub(size(t),j);
% end
% 
% 
% ww = (fspecial('gaussian',[61,1],2)*fspecial('gaussian',[61,1],2)');
% ww = -ww;
% ww = ww-min(ww(:));
% ww = 100*ww;
% 
% for i=1:46
% t = squeeze(fresp(i,:,:));
% rr(i) = sum(sum(t.*ww));
% end
% 
% 
% p = (fspecial('gaussian',[201,1],20)*fspecial('gaussian',[201,1],20)');
% p = -p;
% p = p-min(p(:));
% p = p;
% 
% qq = zeros(201,201); 
% qq(1:100,1) = 100:-1:1;
% qq(102:201,1) = 1:100;
% qq(:,2:end) = qq(:,2:end) + qq(:,1);
% p = 5000*p + qq';
% 
% for i=1:46
% t = squeeze(resp(i,:,:));
% rr(i) = sum(sum(t.*p));
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change from polar to cartesian
[indcartx,indcarty] = meshgrid(-200:200,-200:200);
[poltheta,polrho] = cart2pol(indcarty,indcartx);    % y and x are interchanged to get angle range from 0 to 2pi
qpoltheta = -pi:pi/18:pi-pi/18;
qpolrho = 0:max(max(polrho));
[qrho,qtheta] = meshgrid(qpolrho,qpoltheta);
resp_cart = zeros(size(resp,1),size(qrho,1),size(qrho,2));
for i=1:size(resp,1)
    arr = squeeze(resp(i,:,:));
    qarr = scatteredInterpolant(poltheta(:),polrho(:),arr(:),'natural');
    resp_cart(i,:,:) = reshape(qarr(qtheta(:),qrho(:)),size(qrho,1),size(qrho,2));
    t = squeeze(resp(i,:,:));
    [~,j] = max(t(:));
    [mcart(i),ncart(i)] = ind2sub(size(t),j);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% % % Normalize
% % mi = min(resp_v(:));
% % ma = max(resp_v(:));
% % resp_v = (resp_v-mi)/(ma-mi);

% fSize = properties.l3.fSize;
% fDist = properties.l3.fDist;
% fDim = size(resp_v);
% 
% xstart= 1:fDist:fDim(2)-fSize+1;
% ystart = 1:fDist:fDim(3)-fSize+1;
% 
% resp = zeros(fDim(1),length(xstart),length(ystart),fDim(4),fDim(5));
% 
% for i = 1:length(xstart)
%     for j=1:length(ystart)
%         idxx = xstart(i):xstart(i)+fSize-1;
%         idxy = ystart(j):ystart(j)+fSize-1;
%         resp(:,i,j,:,:) = sum(sum(resp_v(:,idxx,idxy,:,:),2),3);
%     end
% end


end

