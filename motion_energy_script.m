% lenp = [14,8,6,5];
lenp = [34,21,15,11];
velo = [0.5,1,2,4];
angle = [0,20,40,60,80];
figure;
for a=1:5
for v=1:4
dirPath = strcat('Vid2process_crcle_3samp\',num2str(angle(a)),'deg',num2str(velo(v)),'V')


%%
[resp_cart, resp,~,~] = Reich_det(dirPath);
out = classifierOP(dirPath);


% Get the indexes for maximum activity in x, y, speed, velocity direction 
for i=1:size(resp_cart,1)
t = squeeze(resp_cart(i,:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % direc(i,:) = t(i1(i),:);
% % vel(i,:) = t(:,i2(i))';
[vel_direc(i),velocity(i)] = ind2sub(size(t),m);
vel(i,:) = squeeze(t(vel_direc(i),:));
direc(i,:) = squeeze(t(:,velocity(i)));
end

% Get the maximum activity in shape and orientation domain, given the
% position of the object
for i=1:size(out,1)
% t = squeeze(out(i,x(i),y(i),:,:));
t = squeeze(out(i,:,:,:,:));
% % t = marginalize(t,[1,2],'sum');
[~,m] = max(t(:));
% % [i1(i),i2(i)] = ind2sub(size(t),m);
% % orient(i,:) = t(i1(i),:);
% % shape(i,:) = t(:,i2(i))';
[x(i),y(i),shape(i),orientation(i)] = ind2sub(size(t),m);
orient(i,:) = squeeze(t(x(i),y(i),shape(i),:));
shp(i,:) = squeeze(t(x(i),y(i),:,orientation(i)));
end

%  smooth the orientation to remove the classifier artifacts
smoothorient = smoothn(orient,0.2);



%  get new maxima for orientation
[~,orientation] = max(smoothorient,[],2);


% Normalize the orientation and direction matrices
% smoothorient = (smoothorient-min(smoothorient(:)))/(max(smoothorient(:))-min(smoothorient(:)));
% direc = (direc-min(direc(:)))/(max(direc(:))-min(direc(:)));
smoothorient = smoothorient./sum(smoothorient,2);

% Gaussian fitting to the max

% Generate the gaussians
gauss_ORIENT = fspecial('gaussian',[36+1,1],2);
gauss_ORIENT = gauss_ORIENT(1:end-1);
gauss_SHP = fspecial('gaussian',[3,1],0.5);
gauss_VEL = fspecial('gaussian',[283,1],5);
gauss_X = fspecial('gaussian',[35,1],10);
% form_tens = zeros(size(out,1),size(out,2),size(out,3),length(gauss_SHP),length(gauss_ORIENT));
% motion_tens = zeros(size(out,1),size(out,2),size(out,3),length(gauss_VEL),length(gauss_ORIENT));

direc_mat{a,v} = zeros(size(out,1),length(gauss_ORIENT));
orient_mat{a,v} = zeros(size(out,1),length(gauss_ORIENT));
vel_mat{a,v} = zeros(size(out,1),length(gauss_VEL));
shp_mat{a,v} = zeros(size(out,1),length(gauss_SHP));
space_mat{a,v} = zeros(size(out,1),length(gauss_X),length(gauss_X));

for i=1:size(out,1)
    direc_mat{a,v}(i,:) = circshift(gauss_ORIENT,[-18+vel_direc(i)-1,0]);
    
    vel_mat{a,v}(i,:) = circshift(gauss_VEL,[-141+velocity(i)-1,0]);
    
    shp_mat{a,v}(i,:) = circshift(gauss_SHP,[-1+shape(i)-1,0]);
    
    orient_mat{a,v}(i,:) = circshift(gauss_ORIENT,[-18+orientation(i)-1,0]);
    
    if(shape(i)==1)
        orient_mat{a,v}(i,:) = sum(orient_mat{a,v}(i,:))/37;
    end
    
    gauss_y = circshift(gauss_X,[-17+y(i)-1,0]);
    gauss_y = gauss_y(1:size(out,2));
    
    gauss_x = circshift(gauss_X,[-17+x(i)-1,0]);
    gauss_x = gauss_x(1:size(out,2));
    
    space_mat{a,v}(i,:,:) = gauss_x*gauss_y';
%     shape_mat = gauss_shp*gauss_orient';
%     velocity_mat = gauss_vel*gauss_direc';
%     motion_tens(i,:,:,:,:) = reshape(space_mat(:)*velocity_mat(:)',length(gauss_x),length(gauss_y),length(gauss_vel),length(gauss_direc));
%     form_tens(i,:,:,:,:) = reshape(space_mat(:)*shape_mat(:)',length(gauss_x),length(gauss_y),length(gauss_shp),length(gauss_orient));
%     tensor(i,:,:,:,:,:,:) = reshape(t(:)*velocity_mat(:)',length(gauss_x),length(gauss_y),length(gauss_shp),length(gauss_orient),length(gauss_vel),length(gauss_direc));
end

% animacy = Animacy_neuron( vel_mat, direc_mat, shp_mat, smoothorient, space_mat, resp);
% figure;plot(animacy);

end
end
%%
for a=1:5
for v=1:4
[animacy1{a,v},animacy2{a,v}] = Animacy_neuron2( vel_mat{a,v}, direc_mat{a,v}, shp_mat{a,v}, orient_mat{a,v}, space_mat{a,v}, resp, lenp(v));
subplot(4,5,5*(v-1)+a);
% an(v,a) = mean(animacy{a,v}(3:lenp(v)));
plot(animacy1{a,v}(2:end),'b');

% plot(animacy1{a,v}(2:end),'b');
% hold on
% plot(animacy2{a,v}(2:end),'r');

title(['Velocity: ',num2str(velo(v)),'x   ', 'Deviation: ',num2str(angle(a)),' degree']);

an1(a,v) = mean(animacy1{a,v}(3:lenp(v)));
an2(a,v) = mean(animacy2{a,v}(3:lenp(v)));
end
end
an=an1.*an2;
figure;surf(an);

% plotAnimacyResp(dirPath,motion_ten,form_tens);

%% Motion Energy and circular average

% % % e = exp(2*pi*1i*(0:size(orient,4)-1)/size(orient,4));
% % % or = reshape(reshape(orient,size(orient,1)*size(orient,2)*size(orient,3),size(orient,4)).*e,size(orient));
% % % or = sum(or,4);

% % % di = reshape(reshape(direc,size(direc,1)*size(direc,2)*size(direc,3),size(direc,4)).*e,size(direc));
% % % di = sum(di,4);