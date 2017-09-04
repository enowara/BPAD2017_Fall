% main script calling all functions to:
% read in the video
% use facial landmarks to define ROIs
% compute raw PPG for each ROI
% and save

%% initialize
filename =''; %'01_01_01.avi';
fullPath2File = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixedNotxt/EwaLiveCamFixed/cam1/';%'/media/ewa/SH/DatasetsAntiSpoof/3dmadDirectories/Data01Keep/';
vid_phot = 'phot'; %'vid';
fileFormat = '.png';% '';
vid_start = 1;
vid_end = 0;%[]; % remove this many frames from the end of the video

pointsFile = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixed/EwaLiveCamFixed.txt';

%% read video 
[vidSin_out, ~, Fps] = read_video(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end);

% %% load landmarks
img_names = 'frame_00000.png';
[pointsResizedAll] = dlib2FacialPoints(fullPath2File,img_names, pointsFile);
%% track points
vis = 0; % if 1 it will display the image being tracked
[tracked_points] = tracker(vidSin_out, pointsResizedAll, vis);
% TO DO track points from different ROIs of different size etc. 

% or track landmarks within the face mask without eyes and mouth

% or track landmarks for each frame, then redefine ROIs for each frame
%% define ROIs
[~, included_x_All_Final, included_y_All_Final] = find_ROIs(tracked_points, vidSin_out);



% figure('units','normalized','outerposition',[0 0 1 1])
% % c=0;
% n = 10;
% for i = 575:600%1:size(vidSin_out,3)
% %    c = c+1;
% %    subplot(5, 5, c)
%    imshow(vidSin_out(:,:,i))
%    hold on
%    x_access = included_x_All_Final{i};
%    y_access = included_y_All_Final{i};
% 
% %     for n = 1:length(x_access)
% %         c = c+1;
% %         subplot(5, 5, c)
% %         imshow(vidSin_out(:,:,i))
% %         hold on
%         xn_access = cell2mat(x_access(n));
%         yn_access = cell2mat(y_access(n));
%         plot(xn_access, yn_access, 'g.', 'MarkerSize', 0.00001)
%         pause(0.5)
% %     end
%    
%    drawnow
%     
% end

%% get raw PPG
% what to do when there is a varying number of ROIs

[raw_PPG] = raw_PPG_get(vidSin_out, included_x_All_Final, included_y_All_Final);
% TODO: remove or combine very small ROIs, some are large and some are
% small
% clear vidSin_out

%% process raw PPG
[PPG_filt] = procPPG(raw_PPG, Fps);
%% fft
[freq, P] = fft_get(PPG_filt, Fps); % averaged
[freq_g, P_grid] = fft_get_grid(PPG_filt, Fps); % per ROI

figure('units','normalized','outerposition',[0 0 1 1])
for p= 1:size(P_grid,2)
    subplot(ceil(sqrt(size(P_grid,2))), ceil(sqrt(size(P_grid,2))), p)
    plot(freq_g, P_grid(:,p))
end

figure, plot(freq, P)
% TODO: normalize y-axis
%% reject poor ROIs

%% SNR compute

%% extract features

%% Machine learning 