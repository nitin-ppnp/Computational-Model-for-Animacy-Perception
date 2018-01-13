function [ resp ] = classifierOP( dirPath)
%   This module takes in the directory path of the saved output of
%   formapathway before rbf network and outputs the response of the rbf
%   network.
%
% Inputs:
%    input - path to the directory of saved processed output of
%    formapathway before rbf network
% Outputs:
%    Output - response of the rbf network
% 
% Author: Nitin Saini
% Last modified: 12/12/2017

% load the trained and saved model
load('model.mat');
load([dirPath,'/','formresp.mat']);

[y,x] = meshgrid((1:length(properties.l3.yct)),(1:length(properties.l3.xct)));
l3xy = [y(:),x(:)];
catsize = size(formresp.v1f,4);

% The lowest response is -0.45 and hence default response should be less
% than that (-1*ones..)
% resp = zeros(catsize,length(properties.l3.yct),length(properties.l3.xct),properties.numShapes,properties.numDirections);
resp = nan(catsize,length(properties.l3.yct),length(properties.l3.xct),properties.numShapes,properties.numDirections);


%%%%%%%%%%%%%%%
properties.asymmetricData = true;   % for the assymetric rectangle with the eyes
%%%%%%%%%%%%%%

%  Weight sharing and response calculation for each l3 neuron
if properties.asymmetricData
    for j=1:catsize
        for i = 1:size(l3xy,1)
            
            t = formresp.l4resp{l3xy(i,1),l3xy(i,2)}(:,:,:,j);
            X = t(:)-mean(t(:));
            scores = evaluateRBFN(Centers,betas,Theta,X');
            
            %%%%%%%%%%%%%%%%%% Circle %%%%%%%%%%%%%%%%%%%%%
            %         Circle 0degree (all orientations)
            resp(j,l3xy(i,1),l3xy(i,2),1,:) = scores(1);
            
            %%%%%%%%%%%%%%%%%%% Rectangle %%%%%%%%%%%%%%%%%
            %         Rectangle 0degree
            resp(j,l3xy(i,1),l3xy(i,2),2,1) = scores(2);
            %         Rectangle 30, 60, 90 degree
            %         Sequence is not continuous because of the naming
            resp(j,l3xy(i,1),l3xy(i,2),2,2) = scores(4);            % 10 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,3) = scores(15);           % 20 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,4) = scores(26);           % 30 degree   
            resp(j,l3xy(i,1),l3xy(i,2),2,5:10) = scores(32:37);     % 40 - 90 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,11) = scores(3);           % 100 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,12:21) = scores(5:14);     % 110 - 200 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,22:31) = scores(16:25);    % 210 - 300 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,32:36) = scores(27:31);    % 310 - 360 degree
            
            %%%%%%%%%%%%%%%%%%% Triangle %%%%%%%%%%%%%%%%%
            %         Triangle 0, 120, 150, 180,210,240,270, 300, 30, 330, 60, 90 degree
%             resp(j,l3xy(i,1),l3xy(i,2),3,1) = scores(14);
%             
%             resp(j,l3xy(i,1),l3xy(i,2),3,2) = scores(22);
%             
%             resp(j,l3xy(i,1),l3xy(i,2),3,3:4) = scores(24:25);
%             
%             resp(j,l3xy(i,1),l3xy(i,2),3,5:11) = scores(15:21);
%             
%             resp(j,l3xy(i,1),l3xy(i,2),3,12) = scores(23);
        end
        
        %     Normalization
        t = squeeze(resp(j,:,:,:,:));
        mi = min(t(:));
        ma = max(t(:));
        t(isnan(t)) = mi;
        resp(j,:,:,:,:) = (t-mi)/(ma-mi);
    end
else
    for j=1:catsize
        for i = 1:size(l3xy,1)
            
            t = formresp.l4resp{l3xy(i,1),l3xy(i,2)}(:,:,:,j);
            X = t(:)-mean(t(:));
            
            scores = evaluateRBFN(Centers,betas,Theta,X');
            
            %%%%%%%%%%%%%%%%%% Circle %%%%%%%%%%%%%%%%%%%%%
            %         Circle 0degree (all orientations)
            resp(j,l3xy(i,1),l3xy(i,2),1,:) = scores(1);
            
            %%%%%%%%%%%%%%%%%%% Rectangle %%%%%%%%%%%%%%%%%
            %         Rectangle 0degree
            resp(j,l3xy(i,1),l3xy(i,2),2,1) = scores(2);
            %         Rectangle 30, 60, 90 degree
            %         Sequence is not continuous because of the naming
            %         The sequence is 0, 120, 150, 30, 60, 90
            resp(j,l3xy(i,1),l3xy(i,2),2,2:4) = scores(5:7);
            %         Rectangle 120, 150 degree
            resp(j,l3xy(i,1),l3xy(i,2),2,5:6) = scores(3:4);
            %         Other orientations
            resp(j,l3xy(i,1),l3xy(i,2),2,7:12) = resp(j,l3xy(i,1),l3xy(i,2),2,1:6);
            
            %%%%%%%%%%%%%%%%%%% Triangle %%%%%%%%%%%%%%%%%
            %         Triangle 0, 30, 60, 90 degree
            resp(j,l3xy(i,1),l3xy(i,2),3,1:4) = scores(8:11);
            %         Other orientations
            resp(j,l3xy(i,1),l3xy(i,2),3,5:8) = resp(j,l3xy(i,1),l3xy(i,2),3,1:4);
            resp(j,l3xy(i,1),l3xy(i,2),3,9:12) = resp(j,l3xy(i,1),l3xy(i,2),3,1:4);
        end
        
        %     Normalization
% %         t = squeeze(resp(j,:,:,:,:));
% %         mi = min(t(:));
% %         ma = max(t(:));
% %         t(isnan(t)) = mi;
% %         resp(j,:,:,:,:) = (t-mi)/(ma-mi);
    end
end

resp = resp(1:2:end,:,:,:,:);


end

