

Properties;
TrainShapeDir = dir(properties.TrainingPath);
t = ismember({TrainShapeDir.name},{'.','..','desktop.ini'});
TrainShapeDir(t)=[];
TestImageList={};
TrainImageList={};
for i=1:length(TrainShapeDir)
    OrientDir = dir([properties.TrainingPath,'/',TrainShapeDir(i).name]);
    t = ismember({OrientDir.name},{'.','..','desktop.ini'});
    OrientDir(t)=[];
    for j = 1:length(OrientDir)
        TestImageList{i}{j} = [properties.TestPath,TrainShapeDir(i).name,'/',OrientDir(j).name];
        TrainImageList{i}{j} = [properties.TrainingPath,TrainShapeDir(i).name,'/',OrientDir(j).name];
    end
end
testFolders = {};
trainFolders = {};
for m=1:length(TestImageList)
    for n=1:length(TestImageList{m})
        testFolders = [testFolders TestImageList{m}{n}];
        trainFolders = [trainFolders TrainImageList{m}{n}];
    end
end

parfor i=1:length(testFolders)
    Imgs = dir(strcat(trainFolders{i},'\*.png'));
    for noisefac = 0.05:0.1:0.95
        mkdir([testFolders{i},'_',num2str(noisefac)]);
%         fileattrib([testFolders{i},num2str(noisefac)],'+w');
        for j=1:length(Imgs)
            im = imread([trainFolders{i},'/',Imgs(j).name]);
            %             im = rgb2gray(im);
            
            noisyim = imnoise(im,'salt & pepper',noisefac);
            imwrite(noisyim,[testFolders{i},'_',num2str(noisefac),'/',num2str(j),'.png'],'png');
        end
    end
end