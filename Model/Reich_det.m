function [ resp_cart,resp,mcart,ncart] = Reich_det(dirPath )
%   This module takes in the directory path of the saved preprocessed
%   images and performs the motionpathway processing (till veclocity detection).
% Author: Nitin Saini
% Last modified: 12/12/2017

% Load the images as the 3D tensor and the preprocessed saved formpathway
load([dirPath,'/','formresp.mat']);
PXM = loadPixelArray(dirPath);
tens = PXM;

% Get the properties of the model
properties = formresp.properties;


% Filter size for the first layer of the motionpathway
% fsize = properties.reich.fSize;
fsize = 31;



sz = size(tens);

% number of frmaes to be skipped to reduce the unnecessary processing
frame_skp = 2;

sz_resp = [sz(1),sz(2),sz(3)];
sz_resp(3) = floor(sz_resp(3)/frame_skp);

% create the filter
reich_filt = -fspecial('gaussian',[fsize,fsize],10);

% preallocate memory
filt_tens = zeros(sz_resp(1),sz_resp(2),sz_resp(3));
marg_tens = zeros(size(filt_tens));


t = 1;
for i=1:frame_skp:sz(3)
    
    % Marginalization
    marg_tens(:,:,t) = tens(:,:,i);
    
    % Filtering
    pad = marg_tens(:,:,t);
    pad = padarray(pad,[(size(reich_filt,1)-1)/2,(size(reich_filt,1)-1)/2],'replicate');
    filt_tens(:,:,t) = filter2(reich_filt,pad,'valid');
    
    % Normalize
    temp_tens = filt_tens(:,:,t);
    mi = min(temp_tens(:));
    ma = max(temp_tens(:));
    filt_tens(:,:,t) = (temp_tens-mi)/(ma-mi);
    
    t = t+1;
end

%%  Artificially fit gaussian to filt_tens
gauss_X = fspecial('gaussian',[500,1],8);
for i=1:size(filt_tens,3)
    t = squeeze(filt_tens(:,:,i));
    [~,j] = max(t(:));
    [x(i),y(i)] = ind2sub(size(t),j);
    gauss_x = circshift(gauss_X,[-250+x(i)-1,0]);
    gauss_y = circshift(gauss_X,[-250+y(i)-1,0]);
    filt_tens(:,:,i) = gauss_x*gauss_y';
end


% Velocity detection and the resizing the output
for i=2:size(filt_tens,3)
    a = squeeze(filt_tens(:,:,i-1));
    b = squeeze(filt_tens(:,:,i));
    temp = xcorr2(a,b);         % Velocity detection using Reichardt detector
    resp(i,:,:) = temp(300:700,300:700);
    t = squeeze(resp(i,:,:));
    [~,j] = max(t(:));
    [mresp(i),nresp(i)] = ind2sub(size(t),j);
end


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


end

