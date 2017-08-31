% main script calling all functions to:
% read in the video
% use facial landmarks to define ROIs
% compute raw PPG for each ROI
% and save

%% initialize
filename =''; %'01_01_01.avi';
fullPath2File = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixed/EwaFixedCamFixed/cam1/';%'/media/ewa/SH/DatasetsAntiSpoof/3dmadDirectories/Data01Keep/';
vid_phot = 'phot'; %'vid';
fileFormat = '.png';% '';
vid_start = 300;
vid_end = 600;%[];

%% read video 
[vidSin_out, ~, Fps] = read_video(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end);

% %% load landmarks
% imgFolder = 
% img_names = 
% pointsFile = 
[pointsResizedAll] = dlib2FacialPoints(imgFolder,img_names, pointsFile);
%% define ROIs

%% get raw PPG

%% process raw PPG

%% fft

%% reject poor ROIs

%% SNR compute

%% extract features

%% Machine learning 