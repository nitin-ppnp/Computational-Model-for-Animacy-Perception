function [filelist] = getFrameList(stimulipath)


narginchk(1,1)

listing = dir(fullfile(stimulipath, '*.png'));

%extract a list of file names under field {.name} from the {dir} structure,
%convert to integers and sort it
frameindlist = sort(cell2mat(cellfun(@(x) str2num (x(1:end-4)), {listing.name}, 'UniformOutput', 0)));
%convert the list of integers back to list of *.png file names, now sorted
filelist = arrayfun(@(y) [num2str(y), '.png'], frameindlist, 'UniformOutput', 0);


return