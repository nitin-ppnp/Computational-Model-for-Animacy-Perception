function [success] = computeFormOutput(stimulipath,properties)
% Loads the images and processes them for the first two layers of the frompathway. 
% Then prepares the output in the different cells to give input to the RBF network.

% Inputs:
%    input 1 - path to the input videos
%    input 2 - the properties object to run the model  
% Outputs:
%    Output - saves the processed formapathway data (before rbf network) to
%    the mat file and returns the success status

% Author: Nitin Saini
% Last modified: 12/12/2017

%% Load the stored images 
disp(['loading Images from',' ',stimulipath]);
PXM = loadPixelArray(stimulipath);


%% Layer 1 processing (Gabor filters)
disp('Layer 1 Processing with Gabor filters...');
[formresp.v1f, formresp.v1c, formresp.v1pos] = L1(PXM, properties);


%% Layer 2 processing (pooling)
disp('Layer 2 Processing (Max Pooling)...');
[formresp.v4, formresp.v4pos] = L2(formresp.v1f, formresp.v1c,formresp.v1pos,properties);


%% Layer 3 preprocessing (input to the RBF network)
disp('Layer 3 preprocessing...');
formresp.l4resp = L4(formresp.v4,formresp.v4pos,properties); 


%% Save the processed output to the mat file for later usage
formresp.properties = properties;
save(fullfile(stimulipath, strcat('formresp','.mat')),'formresp','-v7.3');

success = true;

end
