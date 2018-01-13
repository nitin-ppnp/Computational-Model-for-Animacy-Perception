%%%%%%%%%% Description %%%%%%%%%%%

% This script runs the formpathway on the videos provided in the 'Videos folder'
% This script reads the input videos, process them through the formapathway
% and store the results in a .mat file
% 
% Inputs:
% 
% Outputs:
%    Output - Sampled images and processed data saved to .mat file
% 
% Author: Nitin Saini
% Last modified: 12/12/2017

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

    
%   Initial processing of the input images (layers before rbf network).

    parfor i=1:length(train)
        computeFormOutput(train{i},properties);
    end
    parfor i=1:length(test)
        computeFormOutput(test{i},properties);
    end
else
    % Read the videos and save them as the sequence of images. The model will
    % take these images as the input.
    conditionList = storeAVIasPNGset(folder);
    parfor i=1:length(conditionList)
%         Process the videos through the formpathway
        computeFormOutput(conditionList{i},properties);
    end
end


