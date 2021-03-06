function [ animacy1,animacy2 ] = Animacy_neuron2( vel_mat, direc_mat, orient_mat,len)
% This function takes in the output of the formapathway and motion pathway and 
% outputs the animacy ratings.  
%
% Inputs:
%    input 1 - velocity matrix
%    input 2 - velocity direction matrix
%    input 3 - orientation direction matrix
%    input 4 - length of video for each velcity config 
% Outputs:
%    Output 1 - animacy realted to the velocity and direction change of the
%    object
%    Output 2 - animacy related to the orientation and motion direction of
%    the object
% 
% Author: Nitin Saini
% Last modified: 12/12/2017

% smooth the input matrices
vel_smth(2:len,:) = smoothn(vel_mat(2:len,:),1);
direc_smth(2:len,:) = smoothn(direc_mat(2:len,:),1);
orient_smth(2:len,:) = smoothn(orient_mat(2:len,:),1);

% get the acceleration using the reichardt detector on top of the velocity
% detector
vel = (1:size(vel_smth,2)).*vel_smth;
vel = vel./283;
for i=2:size(vel_smth,1)
    t = xcorr(direc_smth(i,:),direc_smth(i-1,:));
    direc(i,:) = [35:-1:0,1:35].*t;
    t = xcorr(vel_smth(i,:),vel_smth(i-1,:));
    vel_change(i,:) = (-282:282).*t;
end

% Normalization
direc = direc./35;
vel_change = vel_change./282;

w1 = 5;     % weight given to the absolute velocity neurons 
w2 = 100;   % weight given to the direction encoding neurons
w3 = 1;     % weight given to the velocity change encoding neurons

% Animacy calculation
for i=1:len
    animacy1(i) = (w1*sum(vel(i,:))+w2*sum(direc(i,:))+w3*sum(vel_change(i,:)));
    animacy2(i) = sigmf(sum(orient_smth(i,:).*direc_smth(i,:)),[400,0.06]);
end
% animacy1 = sum(vel,2);
% animacy2 = sum(direc,2);

end

