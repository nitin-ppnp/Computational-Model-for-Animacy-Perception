function [success] = computeFormOutput(stimulipath,properties)
% [formresp] = computeFormOutput(stimulipath);
%          computes responses of the form pathway of the Giese-Poggio 2003
%          model to the stimuli of large shaded walkers. Takes stimulipath as
%          an input - it should contain a list of PNGs representing the
%          relevant frames of the walker.
%                  
%                Based off unpublished code by Martin Giese written for his
%                PhD and subsequent early work. Review doi: 10.1038/nrn1057
%
%                Version 1.1,  07 April 2015 by Leonid Fedorov.
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%

%% Load the stored images 
disp(['loading Images from',' ',stimulipath]);
PXM = loadPixelArray(stimulipath);


%% Layer 1 processing (Gabor filters)
disp('Layer 1 Processing with Gabor filters...');
[formresp.v1f, formresp.v1c, formresp.v1pos] = L1(PXM, properties);


%% Layer 2 processing (pooling for bar detection)
disp('Layer 2 Processing (Max Pooling)...');
[formresp.v4, formresp.v4pos] = L2(formresp.v1f, formresp.v1c,formresp.v1pos,properties);


% % load(fullfile(stimulipath, strcat('formresp','.mat')));

%% Layer 3 processing (for position dependent shape detection)
disp('Layer 3 Processing...');
formresp.l4resp = L4(formresp.v4,formresp.v4pos,properties); 


%% 
formresp.properties = properties;
save(fullfile(stimulipath, strcat('formresp','.mat')),'formresp','-v7.3');

success = true;

end
