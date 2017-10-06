%%%%%%%%%% Description %%%%%%%%%%%

% This script runs the formpathway on the videos provided in the 'Videos folder'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Set video folder. This folder contains videos for model input.
videofolder = 'vid2process60circ';

% check for the existence of the directory
folder = videofolder;
if 7 ~= exist(folder, 'dir')
    error([folder, ' is not a valid directory.'])
end

%% Run the properties script to initialize the model parameters
Properties;

%%

if properties.isTraining
    % Get the path to training images
    [TrainList, TestList] = getImagePath(properties);
    
    % The sequence of images are fed to the model and the output is a cell
    % array 'formrespList'. Each element of this array is a structure, and, corresponds to each
    % video.
    %     formrespList.train = cellfun(@(x) computeFormOutput(x,properties), TrainList, 'UniformOutput', false);
    %     formrespList.test = cellfun(@(x) computeFormOutput(x,properties), TestList, 'UniformOutput', false);
    train = {};
    test = {};
    for m=1:length(TrainList)
        for n=1:length(TrainList{m})
            train = [train TrainList{m}{n}];
        end
    end
    for m=1:length(TestList)
        for n=1:length(TestList{m})
            test = [test TestList{m}{n}];
        end
    end

%     parfor i=1:length(train)
%         computeFormOutput(train{i},properties);
%     end
    parfor i=1:length(test)
        computeFormOutput(test{i},properties);
    end
else
    % Read the videos and save them as the sequence of images. The model will
    % take these images as the input.
    conditionList = storeAVIasPNGset(folder);
    parfor i=1:length(conditionList)
        computeFormOutput(conditionList{i},properties);
    end
end
%%

% %
% %
% % %% temporary script block
% % X=[];
% % y=[];
% % data=[];
% % for n = [1 7]
% %
% %     cat1size = size(formrespList{1,n}.v1f,4);
% %     cat2size = size(formrespList{1,n+7}.v1f,4);
% %
% %     for i=1:cat1size
% %         t = formrespList{1,n}.l4resp{6,6}(:,:,:,i);
% %         arrresp(:,i) = t(:)-mean(t(:));
% %     end
% %     for i=1:cat2size
% %         t = formrespList{1,n+7}.l4resp{6,6}(:,:,:,i);
% %         arrresp(:,i+cat1size) = t(:)-mean(t(:));
% %     end
% %
% %     X = [X;arrresp'];
% %     y = [y;ones(cat1size,1);2*ones(cat2size,1)];
% %     data = [data;[X,y]];
% % end
% %
% % %%
% % % ===================================
% % %     Train RBF Network
% % % ===================================
% %
% % disp('Training the RBFN...');
% %
% % % Train the RBFN using 10 centers per category.
% % [Centers, betas, Theta] = trainRBFN(X, y, 2, true);
% %
% %
% %
% % %%
% % % ========================================
% % %       Measure Training Accuracy
% % % ========================================
% % % Set 'm' to the number of data points.
% % m = size(X, 1);
% %
% % disp('Measuring training accuracy...');
% %
% % numRight = 0;
% %
% % wrong = [];
% %
% % % For each sample...
% % for i = 1 : m
% %     % Compute the scores for both categories.
% %     scores = evaluateRBFN(Centers, betas, Theta, X(i, :));
% %
% %     [maxScore, category] = max(scores);
% %
% %     % Validate the result.
% %     if (category == y(i))
% %         numRight = numRight + 1;
% %     else
% %         wrong = [wrong; i];
% %     end
% %
% % end
% %
% % accuracy = numRight / m * 100;
% % fprintf('Training accuracy: %d / %d, %.1f%%\n', numRight, m, accuracy);
% %
% %
% % %%
% % % ========================================
% % %       Measure Validation data Accuracy
% % % ========================================
% %
% % for n = 2:11
% %
% %     cat1size = size(formrespList{1,n}.v1f,4);
% %     cat2size = size(formrespList{1,n+7}.v1f,4);
% %
% %     for i=1:cat1size
% %         t = formrespList{1,n}.l4resp{6,6}(:,:,:,i);
% %         arrresp(:,i) = t(:)-mean(t(:));
% %     end
% %     for i=1:cat2size
% %         t = formrespList{1,n+7}.l4resp{6,6}(:,:,:,i);
% %         arrresp(:,i+cat1size) = t(:)-mean(t(:));
% %     end
% %
% %     testX = arrresp';
% %     testy = [ones(cat1size,1);2*ones(cat2size,1)];
% %     testdata = [testX,testy];
% %
% %
% %     % Set 'm' to the number of data points.
% %     m = size(testX, 1);
% %
% %     disp('Measuring training accuracy...');
% %
% %     testnumRight = 0;
% %
% %     testwrong = [];
% %
% %     % For each sample...
% %     for i = 1 : m
% %         % Compute the scores for both categories.
% %         scores = evaluateRBFN(Centers, betas, Theta, testX(i, :));
% %
% %         [maxScore, category] = max(scores);
% %
% %         % Validate the result.
% %         if (category == y(i))
% %             testnumRight = testnumRight + 1;
% %         else
% %             testwrong = [testwrong; i];
% %         end
% %
% %     end
% %
% %     testaccuracy = testnumRight / m * 100;
% %     fprintf('Test accuracy: %d / %d, %.1f%%\n', testnumRight, m, testaccuracy);
% %
% % end
% %

