function plotFormOutput(folder, y,x)
%           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Unused function
%           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotFormOutput(pathkey, timestamp);
%          plots responses of the form pathway of the Giese-Poggio 2003
%          model to the stimuli of large shaded walkers. Takes folder as
%          an input - it should contain a computed result. On one figure
%          there're curves of every orientation selective cell within every
%          receptive field over time. The second figure shows a movie of
%          the original walker with overlayed RF activity quiver plot.
%          Arrow orientation indicates filter orientation and arrow length
%          indicates response strength. The movie is shown with fixed delay
%          between frames, independent from original stimuli FPS. All
%          plotted frames of the movie are saved either in the {folder}
%          folder, or in {timestamp} subfolder if {timestamp} is provided.
%
%                Version 1.1,  7 April 2015 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7

%
stimulipath = folder;
% % narginchk(1, 2)
% %
% % if nargin == 1
% %     stimulipath = folder;
% % elseif nargin == 2
% %     stimulipath = fullfile(folder, timestamp);
% % end

formdata = load(fullfile(stimulipath, 'formresp.mat'));
V4 = formdata.formresp.v4;
V4pos = [formdata.formresp.properties.rfmap.v4xct;formdata.formresp.properties.rfmap.v4yct];

nrows = size(V4, 1);
ncols = size(V4, 2);
% % f1 = figure;
% % for rowInd = 1 : nrows
% %     for colInd = 1 : ncols
% %         subplot(nrows, ncols, nrows*(rowInd - 1) + colInd); plot(squeeze(V4(rowInd, colInd, :, :))');
% %         title(['Cells at row: ', num2str(rowInd), ' column: ', num2str(colInd)]);
% %     end
% % end
% neuron = formdata.formresp.properties.l3neuronToTrain;
neuron = [11,11];


listing = getFrameList(stimulipath);


figure;

for ind = 1:numel(listing)
    
    %     f = figure;
    % figure(f);
    % fpos = get(f, 'position');
    [posX, posY] = meshgrid(V4pos(1, :), V4pos(2, :));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%
    [~,maxid] = max(V4(:,:,:,ind),[],3);
    V = zeros(size(V4(:,:,:,ind)));
    for i1 = 1:size(V4,1)
        for i2 = 1:size(V4,2)
            V(i1,i2,maxid(i1,i2)) = V4(i1,i2,maxid(i1,i2),ind);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%
    
    
    img_in = im2double(imread(fullfile(stimulipath,listing{ind})));
    %     if size(img_in,3) > 1, img_in(:,:,2:3) = []; end
    %     if ~isequal([fpos(3), fpos(4)], size(img_in))
    %         set(f, 'position', [0 0 size(img_in)])
    %     end
    imshow(img_in, 'Border', 'tight'); hold on;
    for i = 1:8
        %         oneresp = V4(:, :, i, ind);
        oneresp = V(:, :, i)/4;
        quiver(posX, posY, oneresp*sin((i-1)*pi/8)*10, oneresp*cos((i-1)*pi/8)*10, 0,'LineWidth',4);
    end
    % %     %bake the response amplitudes into the image
    % %     text(10, 10, ['response bounds: ', num2str(bounds(V4(:, :, :, ind)))]);
    % %     text(10, 25, 'response means per RF:');
    % %     text(10, 90, num2str(mean(V4(:, :, :, ind),3)),'BackgroundColor',[0.5 0.5 0.5]);
    
    
    %     currFrame = getframe(gcf);
    %     if ~isdir(fullfile(stimulipath,'formquiver')), mkdir(stimulipath,'formquiver'); end
    %     imwrite(currFrame.cdata, fullfile(stimulipath,'formquiver',['q',listing{ind}]),'PNG');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot the l3 rec field
    coords = formdata.formresp.properties.rfmap.v4(neuron(1),neuron(2),:,:);
    coords = squeeze(coords);
    patch(coords(:,2),coords(:,1),'b','FaceAlpha',0.3);
    
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    waitforbuttonpress;
    
end





