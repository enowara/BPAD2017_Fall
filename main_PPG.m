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

%% load 68 points and add forehead and face mask from it - no eyes or mouth
% if facial landmarks are only detected for the first frame, only feed in
% the first frame to define the mask and points
[faceMask, firstPoints_augmented] = face_points_mask(pointsResizedAll, vidSin_out(:,:,1));

%% track points
vis = 0; % if 1 it will display the image being tracked
% [tracked_points] = tracker(vidSin_out, pointsResizedAll, vis);
n_tr = 20;
[tracked_points_mask] = KLTtrackerMASK(vidSin_out, faceMask, n_tr, 0);

%% define ROIs

[gridPointsF, gridPointsL, gridPointsR]= forehead_LRCheek(tracked_points_mask, pointsResizedAll);
% [~, included_x_All_Final, included_y_All_Final] = find_ROIs(tracked_points, vidSin_out);

[included_x_All_Final, included_y_All_Final] = find_ROIs2(firstPoints_augmented, tracked_points_mask);

% figure('units','normalized','outerposition',[0 0 1 1])
% % c=0;
% n = 10;
% for i = 1:size(vidSin_out,3)
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
% %         pause(0.5)
% %     end
%    
%    drawnow
%     
% end

%% get raw PPG
% what to do when there is a varying number of ROIs

% raw_PPG = raw_PPG_get(vidSin_out, included_x_All_Final, included_y_All_Final);
% raw_PPG = raw_PPG_get_rigid_grid(vidSin_out, tracked_points, 10);

% figure('units','normalized','outerposition',[0 0 1 1])
% for i = 1:10:size(vidSin_out,3)
%     imshow(vidSin_out(:,:,i))
%     hold on
%     plot(tracked_points_mask(t,:,1), tracked_points_mask(t,:,2), 'g.')
%     drawnow
% end
% TODO: remove or combine very small ROIs, some are large and some are
% small
% clear vidSin_out

raw_PPGF = raw_PPG_get_rigid_grid(vidSin_out, gridPointsF, 10);
raw_PPGL = raw_PPG_get_rigid_grid(vidSin_out, gridPointsL, 10);
raw_PPGR = raw_PPG_get_rigid_grid(vidSin_out, gridPointsR, 10);

% raw_PPG_all = raw_PPG_get_rigid_grid(vidSin_out, tracked_points_mask, 10);



%% process raw PPG
[PPG_filtF] = procPPG(raw_PPGF, Fps);
[PPG_filtL] = procPPG(raw_PPGL, Fps);
[PPG_filtR] = procPPG(raw_PPGR, Fps);

% [PPG_filt_all] = procPPG(raw_PPG_all, Fps);
% [PPG_filt] = procPPG(raw_PPG, Fps);
%% fft
[freqF, PF] = fft_get(PPG_filtF, Fps); % averaged
[freqL, PL] = fft_get(PPG_filtL, Fps); % averaged
[freqR, PR] = fft_get(PPG_filtR, Fps); % averaged

% [freq_all, P_all] = fft_get(PPG_filt_all, Fps); % averaged

figure, hold on, plot(freqF, PF, 'r'), plot(freqL, PL, 'g'), plot(freqR, PR, 'b')
% figure, hold on, plot(freq_all, P_all, 'c')



% [freq, P] = fft_get(PPG_filt, Fps); % averaged
% [freq_g, P_grid] = fft_get_grid(PPG_filt, Fps); % per ROI
% 
% figure('units','normalized','outerposition',[0 0 1 1])
% for p= 1:size(P_grid,2)
%     subplot(ceil(sqrt(size(P_grid,2))), ceil(sqrt(size(P_grid,2))), p)
%     plot(freq_g, P_grid(:,p))
% end
% 
% figure, plot(freq, P)
% TODO: normalize y-axis
%% reject poor ROIs

%% SNR compute

%% extract features
% max peak location, equivalent to HR estimate
% SNR, equivalent to goodness
% SNR around max peak from spatial average over the whole face without eyes
    % and mouth
% ratio of 1st max peak to 2nd max peak
% 
%% Machine learning 