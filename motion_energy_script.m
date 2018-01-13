%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to get the results of the model for the Tremoulet
% and Feldman (2000) like input videos. It loads the preprocessed and saved
% data and processes it thorugh the complete formpathway and the motion
% pathway (till velocity detector i.e. layer 2 of the motion pathway).
%
% Inputs:
%    
% Outputs:
%    Output - Animacy rating for each input video
% 
% Author: Nitin Saini
% Last modified: 12/12/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the time length, velocity change and the angle for running through
% the loop
lenp = [32,20,14,11];   % different time values for each video since higher velocity video has less on screen time of object
velo = [0.5,1,2,4];     % 4 velocity configs
angle = [0,20,40,60,80];% 5 angle configs    

% for each velocity and each angle
for a=1:5
    for v=1:4
        
        %         get the directory path
        dirPath = strcat('Vid2process_crcle_3samp\',num2str(angle(a)),'deg',num2str(velo(v)),'V')       % to print during runtime
        
        %         Process through the motion pathway (till velocity detection)
        [resp_cart, resp] = Reich_det(dirPath);
        
        %         Process through the RBF network
        out = classifierOP(dirPath);
        
        
        % Get the indexes for maximum activity in x, y, speed, velocity direction
        for i=1:size(resp_cart,1)
            t = squeeze(resp_cart(i,:,:));
            [~,m] = max(t(:));
            [vel_direc(i),velocity(i)] = ind2sub(size(t),m);
            vel(i,:) = squeeze(t(vel_direc(i),:));
            direc(i,:) = squeeze(t(:,velocity(i)));
        end
        veloc{a,v} = velocity;
        
        
        % Get the maximum activity in shape and orientation domain, given the
        % position of the object
        for i=1:size(out,1)
            t = squeeze(out(i,:,:,:,:));
            [~,m] = max(t(:));
            [x(i),y(i),shape(i),orientation(i)] = ind2sub(size(t),m);
            orient(i,:) = squeeze(t(x(i),y(i),shape(i),:));
            shp(i,:) = squeeze(t(x(i),y(i),:,orientation(i)));
        end
        
        %  smooth the orientation to remove the classifier artifacts
        smoothorient = smoothn(orient,0.2);
        
        
        
        %  get new maxima for orientation
        [~,orientation] = max(smoothorient,[],2);
        
        
        % Normalize the orientation and direction matrices
        smoothorient = smoothorient./sum(smoothorient,2);
        
        
        %%%%%%%%%%%%%%%%% Gaussian fitting to the max %%%%%%%%%%%%%%%%%%%%%%%%
        
        % Generate the gaussians
        gauss_ORIENT = fspecial('gaussian',[36+1,1],2);
        gauss_ORIENT = gauss_ORIENT(1:end-1);
        gauss_SHP = fspecial('gaussian',[3,1],0.5);
        gauss_VEL = fspecial('gaussian',[283,1],5);
        gauss_X = fspecial('gaussian',[35,1],10);
        
        %         Allocate memory for the variables
        direc_mat{a,v} = zeros(size(out,1),length(gauss_ORIENT));
        orient_mat{a,v} = zeros(size(out,1),length(gauss_ORIENT));
        vel_mat{a,v} = zeros(size(out,1),length(gauss_VEL));
        shp_mat{a,v} = zeros(size(out,1),length(gauss_SHP));
        space_mat{a,v} = zeros(size(out,1),length(gauss_X),length(gauss_X));
        
        for i=1:size(out,1)
            
            %             Adjust the gaussians to align the maxima
%             velocity direction of object
            direc_mat{a,v}(i,:) = circshift(gauss_ORIENT,[-18+vel_direc(i)-1,0]);
%             velocity of the object
            vel_mat{a,v}(i,:) = circshift(gauss_VEL,[-141+velocity(i)-1,0]);
%             shape of the object
            shp_mat{a,v}(i,:) = circshift(gauss_SHP,[-1+shape(i)-1,0]);
%             orientation direction of the object
            orient_mat{a,v}(i,:) = circshift(gauss_ORIENT,[-18+orientation(i)-1,0]);
            
            %             Distribute the response energy if the object is symmetric
            if(shape(i)==1)
                orient_mat{a,v}(i,:) = sum(orient_mat{a,v}(i,:))/15.5;
            end
            
%             fit the gaussian for y coordinate of position of the object
            gauss_y = circshift(gauss_X,[-17+y(i)-1,0]);
            gauss_y = gauss_y(1:size(out,2));
%             fit the gaussian for x coordinate of position of the object
            gauss_x = circshift(gauss_X,[-17+x(i)-1,0]);
            gauss_x = gauss_x(1:size(out,2));
            
            space_mat{a,v}(i,:,:) = gauss_x*gauss_y';
        end
        
    end
end
%%  Getting the results
for a=1:5
    for v=1:4
        
        %         Get the animacy results
        [animacy1{a,v},animacy2{a,v}] = Animacy_neuron2( vel_mat{a,v}, direc_mat{a,v}, orient_mat{a,v}, lenp(v));
        
    end
end

%%  Plotting subroutines (enable if required)
if(0)
    for a=1:5
        for v=1:4
            subplot(4,5,5*(v-1)+a);
            % an(v,a) = mean(animacy{a,v}(3:lenp(v)));
            plot(animacy1{a,v}(2:end),'b');
            
            % plot(animacy1{a,v}(2:end),'b');
            % hold on
            % plot(animacy2{a,v}(2:end),'r');
            
            title(['Velocity: ',num2str(velo(v)),'x   ', 'Deviation: ',num2str(angle(a)),' degree']);
            
            an1(a,v) = mean(animacy1{a,v}(3:lenp(v)));
            an2(a,v) = mean(animacy2{a,v}(3:lenp(v)));
            animacy{a,v} = animacy1{a,v}.*animacy2{a,v};
            an(a,v) = mean(animacy{a,v}(3:lenp(v)));
        end
    end
    % an=an1.*an2;
    figure;surf(an);
    
    % plotAnimacyResp(dirPath,motion_ten,form_tens);
end

%%  Alternate smoothing of the gaussians in time and space (use this peice of code if required)
% 
% for a=1:5
%     for v=1:4
%         vel_smth{a,v} = zeros(34,283);
%         direc_smth{a,v} = zeros(34,36);
%     end
% end
% for a=1:5
%     for v=1:4
%         vel_smth{a,v}(2:lenp(v),:) = smoothn(vel_mat{a,v}(2:lenp(v),:),1);
%         direc_smth{a,v}(2:lenp(v),:) = smoothn(direc_mat{a,v}(2:lenp(v),:),1);
%     end
% end
