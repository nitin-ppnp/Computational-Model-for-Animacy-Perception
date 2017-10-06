function [ animacy ] = Animacy_neuron( vel_mat, direc_mat, shp_mat, orient_mat, space_mat, motion_resp_pol)
%ANIMACY_NEURON Summary of this function goes here
%   Detailed explanation goes here

% p = (fspecial('gaussian',[401,1],50)*fspecial('gaussian',[401,1],50)');
% p = -p;
% p = p-min(p(:));

qq = zeros(401,401);
qq(1:200,1) = 200:-1:1;
qq(202:401,1) = 1:200;
qq(:,2:end) = qq(:,2:end) + qq(:,1);
% p = 100000*p + qq';
q = zeros(401,401);
q(1,:) = 0:400;
q(2:end,:) = q(2:end,:)+q(1,:);

p = 2.5*qq+q;

[indcartx,indcarty] = meshgrid(-200:200,-200:200);
[poltheta,polrho] = cart2pol(indcarty,indcartx);
qpoltheta = -pi:pi/200:pi;
qpolrho = 0:400;
[qrho,qtheta] = meshgrid(qpolrho,qpoltheta);
qarr = scatteredInterpolant(qtheta(:),qrho(:),p(:));
arr = reshape(qarr(poltheta(:),polrho(:)),size(qrho,1),size(qrho,2));

% arr = smoothn(arr,4);

for i=1:size(motion_resp_pol,1)
    t = squeeze(motion_resp_pol(i,:,:));
    animacy(i) = sum(orient_mat(i,:).*direc_mat(i,:))*sum(sum(t.*arr));
%     animacy(i) = sum(sum(t.*arr));
end


% animacy = sum(direc_mat.*orient_mat,2);

end

