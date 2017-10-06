function [videoNameList] = storeAVIasPNGset(folder)

%storeAVIasPNGset(folder) stores each AVI from a given folder as a set of
%       PNGs corresponding to its frames, in folders identical to AVI names
%        
%
%                Version 1.6,  07 April 2016 by Leonid Fedorov
%
%                Tested with MATLAB 8.4 on a Xeon E5-1620 3.6Ghz under W7
%
%


narginchk(1,1)

%NOTE: dir() actually takes care of potential double slashes in this wildcard
%call, but not of the case of no slashes; hence appending filesep()
aviListing = dir(strcat(folder, filesep, '*.avi'));
videoNameList = {};
for i = 1 : numel(aviListing),
    [filePath, fileName, fileExt] = fileparts(aviListing(i).name); 
    videoName = fullfile(folder, fileName);
    videoNameList = [videoNameList; {videoName}]; 
    if ~isdir(videoName)
        mkdir(videoName);
    end
end


for i = 1 : numel(videoNameList)
    fullVideoName = fullfile(folder, aviListing(i).name);
    video = VideoReader(fullVideoName);
    display(fullVideoName)

    tic;
    %read() will be deprecated, unfortunately, but its more useful to set 
    %the start and end frame explicitly, e.g. [1 Inf] means 'first to last'
    frames = read(video, [1 Inf]); 
    
    %reading all frames before processing them can be very slow, however:
    display(['Read ', num2str(size(frames,4)),' frames from ', video.name,' in ', num2str(toc),' seconds.']);
    
    for frindex = 1 :3: size(frames, 4)
        videoFrame = squeeze(frames(:, :, :, frindex));
%         videoFrame(:,:,2:3) = [];
%         videoFrame = videoFrame(50:850,300:600); %cut the window from the video if needed
%NOTE: below its very important to explictily convert the fullfile() output with char(),
%otherwise the imwrite() function won't be able to parse its arguments.
        imwrite(videoFrame, char(fullfile(videoNameList(i), strcat(num2str(frindex),'.png'))), 'PNG');

        %imshow(videoFrame);
    end
end

return