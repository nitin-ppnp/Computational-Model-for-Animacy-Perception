% function [  ] = plotAnimacyResp(dirPath)
%PLOTANIMACYRESP Summary of this function goes here
%   Detailed explanation goes here

%
stimulipath = dirPath;

formdata = load(fullfile(stimulipath, 'formresp.mat'));
V4pos = [formdata.formresp.properties.rfmap.l3xct;formdata.formresp.properties.rfmap.l3yct];


listing = getFrameList(stimulipath);
% 
% O = marginalize(form_tens,[4],'sum');
% D = marginalize(motion_tens,[4],'sum');
% 
% animacy_factor = sum(marginalize(O,[2,3],'sum').*marginalize(D,[2,3],'sum'),2);

% f = figure;
% set(f,'Visible','off');

for ind = 1:numel(listing)-6
%     t = D(ind,:,:,:);
%     [~,m] = max(t(:));
%     [~,neuron(2),neuron(1),~] = ind2sub(size(t),m);
    
    [posX, posY] = meshgrid(V4pos(1, :), V4pos(2, :));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % % % t = squeeze(space(:,:,ind));
    % % % [~,maxid] = max(t(:));
    % % % [m1,m2] = ind2sub(size(t),maxid);
    % % %
    % % % t = squeeze(velocity(:,:,ind));
    % % % [~,maxid] = max(t(:));
    % % % [m3,m4] = ind2sub(size(t),maxid);
    % % % D = zeros(size(space,1),size(space,2),size(velocity,1));
    % % % D(m1,m2,m3) = velocity(m3,m4,ind);
    % % %
    % % % t = squeeze(shape(ind,m1,m2,:));
    % % % [~,maxid] = max(t(:));
    % % % [m3,m4] = ind2sub(size(t),maxid);
    % % % O = zeros(size(space,1),size(space,2),size(shape,1));
    % % % O(m1,m2,m4) = shape(m3,m4,ind);
    
    %%%%%%%%%%%%%%%%%%%%%%%
    
    
    img_in = im2double(imread(fullfile(stimulipath,listing{2*ind-1})));
    %     if size(img_in,3) > 1, img_in(:,:,2:3) = []; end
    %     if ~isequal([fpos(3), fpos(4)], size(img_in))
    %         set(f, 'position', [0 0 size(img_in)])
    %     end
    imshow(img_in, 'Border', 'tight'); hold on;
%     for i = 1:36
%         %         oneresp = V4(:, :, i, ind);
%         oresp = 4*squeeze(O(ind,:, :, i));
%         quiver(posX, posY, oresp*sin((i-1)*pi/18)*10, oresp*cos((i-1)*pi/18)*10, 0,'color','g');
%         dresp = 4*squeeze(D(ind,:, :, i));
%         quiver(posX, posY, dresp*sin((i-1)*pi/18)*10, dresp*cos((i-1)*pi/18)*10, 0,'color','b');
%     end
    posX = formdata.formresp.properties.rfmap.l3xct(x(ind));
    posY = formdata.formresp.properties.rfmap.l3yct(y(ind));
    oresp = squeeze(orient(ind,:));
    [m,i] = max(oresp(:));
%     oresp(:)=0;
%     oresp(i)=m;
    oresp = 3*oresp;
    dresp = squeeze(direc(ind,:));
    [m,i] = max(dresp(:));
    dresp(:)=0;
    dresp(i)=m;
    dresp = vel_direc(ind)*10*dresp;
    for i = 1:36       
%         quiver(posY,posX,oresp*sin((i-1)*pi/18)*10, oresp*cos((i-1)*pi/18)*10, 0,'color','g');
%         quiver(posY,posX, dresp(i)*sin((i-1)*pi/18)*10, dresp(i)*cos((i-1)*pi/18)*10, 0,'color','b','LineWidth',1,'MaxHeadSize',0.5);
        quiver(posY,posX, oresp(i)*sin((i-1)*pi/18)*10, oresp(i)*cos((i-1)*pi/18)*10, 0,'color','B','LineWidth',0.5,'MaxHeadSize',0.5);
    end

    
        coords = formdata.formresp.properties.rfmap.l3(y(ind),x(ind),:,:);
        coords = squeeze(coords);
        patch(coords(:,2),coords(:,1),'y','FaceAlpha',0.1);
    
    %     coords = formdata.formresp.properties.rfmap.l3(neuron(1)-2,neuron(2),:,:);
    %     coords = squeeze(coords);
    %     patch(coords(:,2),coords(:,1),'b','FaceAlpha',0.3);
    %
    %     coords = formdata.formresp.properties.rfmap.l3(neuron(1),neuron(2)-2,:,:);
    %     coords = squeeze(coords);
    %     patch(coords(:,2),coords(:,1),'b','FaceAlpha',0.3);
    %
    %     coords = formdata.formresp.properties.rfmap.l3(neuron(1)+2,neuron(2),:,:);
    %     coords = squeeze(coords);
    %     patch(coords(:,2),coords(:,1),'b','FaceAlpha',0.3);
    %
    %     coords = formdata.formresp.properties.rfmap.l3(neuron(1),neuron(2)+2,:,:);
    %     coords = squeeze(coords);
    %     patch(coords(:,2),coords(:,1),'b','FaceAlpha',0.3);
    
    
% % % %     hold off;
% % % %     ax = axes('Position',[.7,.2,.2,.2]);
% % % %     box on;
% % % %     p = zeros(size(animacy_factor));
% % % %     p(6:ind) = animacy_factor(6:ind);
% % % %     %     xticks(1:length(p));
% % % %     %     yticks([0,0.5,1,1.5]);
% % % %     plot((1:length(p)),p);
% % % %     hold on
% % % %     plot([ind,ind],[0,1],'r');
% % % %     xlabel('time');
% % % %     ylabel('response');
% % % %     
% % % %     
% % % %     
%     print('-dpng', strcat(num2str(ind),'.png'), '-r300');
    
%     waitforbuttonpress;
end

