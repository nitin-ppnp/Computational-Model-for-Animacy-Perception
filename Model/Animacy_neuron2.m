function [ animacy1,animacy2 ] = Animacy_neuron2( vel_mat, direc_mat, shp_mat, orient_mat, space_mat, motion_resp_pol,len)
%ANIMACY_NEURON Summary of this function goes here
%   Detailed explanation goes here

vel_smth(2:len,:) = smoothn(vel_mat(2:len,:),1);
direc_smth(2:len,:) = smoothn(direc_mat(2:len,:),1);
orient_smth(2:len,:) = smoothn(orient_mat(2:len,:),1);

vel = (1:size(vel_smth,2)).*vel_smth;
vel = vel./283;
for i=2:size(vel_smth,1)
    t = xcorr(direc_smth(i,:),direc_smth(i-1,:));
    direc(i,:) = [35:-1:0,1:35].*t;
    t = xcorr(vel_smth(i,:),vel_smth(i-1,:));
    vel_change(i,:) = (-282:282).*t;
end
direc = direc./35;
vel_change = vel_change./282;
% direc = 200*[18:-1:0,1:17].*direc_mat;

w1 = 5;
w2 = 100;
w3 = 1;


for i=1:len
    animacy1(i) = (w1*sum(vel(i,:))+w2*sum(direc(i,:))+w3*sum(vel_change(i,:)));
%     animacy2(i) = sum(orient_mat(i,:).*direc_mat(i,:));
    animacy2(i) = sigmf(sum(orient_smth(i,:).*direc_smth(i,:)),[400,0.06]);
%     animacy(i) = sum(orient_mat(i,:).*direc_mat(i,:))*(w1*sum(vel(i,:))+w2*sum(direc(i,:))+w3*sum(vel_change(i,:)));
end
% animacy1 = sum(vel,2);
% animacy2 = sum(direc,2);

end

