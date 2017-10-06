%% Model Params
properties.isTraining = false;
properties.TrainingPath = 'Data/Training_data/';
properties.TestPath = 'Data/Test_data/';
properties.l3neuronToTrain = [9,9];
properties.TestDataPerCat = 10;
properties.TrainDataPerCat = 1;
properties.frame.dim = [500,500];
properties.numShapes = 3;
properties.numDirections = 36;  % [0 30 60 90 120 150 180 210 240 270 300 330]
properties.MatlabRBFN = false;
properties.symmetricData = false;

%% Layer 1 Properties
properties.l1.gaborLen = 5;
properties.l1.gaborWidth = properties.l1.gaborLen*0.7;
properties.l1.gaborWaveNum = 2 * pi / properties.l1.gaborLen / 1.8;
properties.l1.threshold = 1;
properties.l1.normFactor = 5;
properties.l1.ygct = 11:4:(500-10);
properties.l1.xgct = 11:4:(500-10);



%% Layer 2 properties
properties.l2.ngbVec = (-3:3);
properties.l2.numV4rf = [41,41];
properties.l2.threshold = 0.01;
properties.l2.normFactor = 1;

%% Layer 4 properties

% properties.l3.ngbVec = (-2:2);
% properties.l3.numV4rf = [5,5];
properties.l3.fSize = 7;
properties.l3.fDist = 1;

%% Reichardt detector layer

properties.reich.fSize = 7;
properties.reich.fDist = 1;  % Now it is fixed to value 1


%% Receptive fields info
properties = rfmapping(properties);