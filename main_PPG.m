% main script calling all functions to:
% read in the video
% use facial landmarks to define ROIs
% compute raw PPG for each ROI
% and save

%% initialize
filename 
fullPath2File 
vid_phot 
fileFormat 
vid_start 
vid_end

%% read video 
[vidSin_out, ~, Fps] = read_video(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end);

%% load landmarks
[pointsResizedAll] = dlib2FacialPoints(imgFolder,img_names, pointsFile);
%% define ROIs

