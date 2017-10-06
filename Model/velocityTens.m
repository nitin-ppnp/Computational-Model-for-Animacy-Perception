function [ outTens ] = velocityTens( tens )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


c = 0:30:330;
c = [c-9;c-6;c-3;c;c+3;c+6;c+9 ];
c = c(:);
l = 1:length(c);
l = ceil(l/7);
l=l';
[c_angle,b_angle,t_angle] = trainRBFN(c,l,1,false);
[c_amp,b_amp,t_amp] = trainRBFN([1;2;3;4;5;6],[1;1;2;2;3;3],1,false);

angle = zeros(size(tens,1),12);
amp = zeros(size(tens,1),3);

%  Output Tensor
outTens = zeros(size(tens,1),12,3);


for i=2:size(tens,1)
    %     Take the values from previous and present frame
%     t1 = sum(sum(squeeze(tens(i-1,:,:,:,:)),4),3);
%     t2 = sum(sum(squeeze(tens(i,:,:,:,:)),4),3);
    t1 = marginalize(tens(i-1,:,:,:,:),[4,5]);
    t2 = marginalize(tens(i,:,:,:,:),[4,5]);
    %     Get the position of the object by looking for max response
    [~,i1] = max(t1(:));
    [~,i2] = max(t2(:));
    [x1,y1] = ind2sub(size(t1),i1);
    [x2,y2] = ind2sub(size(t2),i2);
    %     Get the change is position
    x = x2-x1;
    y = y2-y1;
    
    %     Get the amplitude of the velocity
    vel_amp = sqrt(x^2+y^2);
    
    if vel_amp~=0
        vel_angle = mod(atan(y/x),2*pi)*180/pi;
        %         Angle between 0 and 345 should be negative as the RBFN is trained
        %         that way
        if vel_angle > 345
            vel_angle = vel_angle-360;
        end
        angle(i,:) = evaluateRBFN(c_angle,b_angle,t_angle,vel_angle);
    else
        angle(i,:) = angle(i-1,:);
    end
    amp(i,:) = evaluateRBFN(c_amp,b_amp,t_amp,vel_amp);
    outTens(i,:,:) = angle(i,:)'*amp(i,:);
end

angle(1,:) = angle(2,:);
amp(1,:) = amp(2,:);
outTens(1,:,:) = outTens(2,:,:);

% Normalization
mi = min(outTens(:));
ma = max(outTens(:));
outTens = (outTens-mi)/(ma-mi);
end

