function [ TrainImageList, TestImageList] = getImagePath( properties )
%GETTRAININGIMAGEPATH Summary of this function goes here
%   Detailed explanation goes here

TrainShapeDir = dir(properties.TrainingPath);
t = ismember({TrainShapeDir.name},{'.','..','desktop.ini'});
TrainShapeDir(t)=[];
TrainImageList = {};
for i=1:length(TrainShapeDir)
    OrientDir = dir([properties.TrainingPath,'/',TrainShapeDir(i).name]);
    t = ismember({OrientDir.name},{'.','..','desktop.ini'});
    OrientDir(t)=[];
    for j = 1:length(OrientDir)
        TrainImageList{i}{j} = strcat(properties.TrainingPath,TrainShapeDir(i).name,filesep,OrientDir(j).name);
    end
end

TestShapeDir = dir(properties.TestPath);
i = ismember({TestShapeDir.name},{'.','..','desktop.ini'});
TestShapeDir(i)=[];
TestImageList = {};
for i=1:length(TestShapeDir)
    OrientDir = dir([properties.TestPath,'/',TestShapeDir(i).name]);
    t = ismember({OrientDir.name},{'.','..','desktop.ini'});
    OrientDir(t)=[];
    for j = 1:length(OrientDir)
        TestImageList{i}{j} = strcat(properties.TestPath,TestShapeDir(i).name,filesep,OrientDir(j).name);
    end
end

end


