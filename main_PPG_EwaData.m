% main script calling all functions to:
% read in the video
% use facial landmarks to define ROIs
% compute raw PPG for each ROI
% and save


%% initialize
filename =''; %'01_01_01.avi';
vid_phot = 'phot'; %'vid';
fileFormat = '.png';% '';
vid_start = 1;
vid_end = 0;%[]; % remove this many frames from the end of the video

mainFolderVids = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixedNotxt/';
mainFolderPnts = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixed/';

vidList = dir(mainFolderVids);
for vidNum = [4:6, 8:length(vidList)]
    
    vidName = vidList(vidNum).name; % EwaLiveCamFixed/cam1/';
    fullPath2File = [mainFolderVids vidName '/cam1/'];
    pointsFile = [mainFolderPnts vidName '.txt'];
    datte = '09_05/';
    fullPath2Save = ['../../Results/EwaData/' datte];
    mkdir(fullPath2Save)

    addpath('/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Code/temp_helper_functions/altmany-export_fig-5be2ca4/');
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
    [gridPoints]= forehead_LRCheek(tracked_points_mask, pointsResizedAll);
    % [~, included_x_All_Final, included_y_All_Final] = find_ROIs(tracked_points, vidSin_out);

    % [included_x_All_Final, included_y_All_Final] = find_ROIs2(firstPoints_augmented, tracked_points_mask);

    %% get raw PPG
    for g = 1:length(gridPoints)
        raw_PPG{g} = raw_PPG_get_rigid_grid(vidSin_out, gridPoints{g}, 20);
    end
    raw_PPG_all = raw_PPG_get_rigid_grid(vidSin_out, tracked_points_mask, 20);

    clear vidSin_out

    %% process raw PPG
    for g = 1:length(gridPoints)
        PPG_filt{g} = procPPG(raw_PPG{g}, Fps);
    end

    [PPG_filt_all] = procPPG(raw_PPG_all, Fps);
    %% fft
    P_gAll = [];
    figure('units','normalized','outerposition',[0 0 1 1])
    for g = 1:length(gridPoints)
        subplot(ceil(sqrt(length(gridPoints))), ceil(sqrt(length(gridPoints))), g)
        [freq_g, P_g] = fft_get(PPG_filt{g}, Fps); % averaged
        plot(freq_g, P_g)
        title(num2str(g))
        P_gAll = [P_gAll P_g];
    end
    saveas(gcf, [fullPath2Save num2str(vidNum) '_ROIsPPG_' '.fig']) 
    [imageData, alpha] = export_fig([fullPath2Save num2str(vidNum) '_ROIsPPG_'], '-png', '-q101');
    close

    [freq_all, P_all] = fft_get(PPG_filt_all, Fps); % averaged
    figure, hold on, plot(freq_all, P_all, 'c')

    saveas(gcf, [fullPath2Save num2str(vidNum) '_average_PPG_' '.fig']) 
    [imageData, alpha] = export_fig([fullPath2Save num2str(vidNum) '_average_PPG_'], '-png', '-q101');
    close

    %% reject poor ROIs

    %% extract features
    
    % normalize SNR to some scale
    % max peak location, equivalent to HR estimate
    % SNR, equivalent to goodness
    % for all grids
    [goodnessRatio_grids, freqMax, areaSignal, areaNoise] = measureSNRgrid(P_gAll, freq_g, 0.2);
    % for averaged PPG
    [goodnessRatio_average, freqMax_average, areaSignal_average, areaNoise_average] = measureSNR(P_all, freq_all, 0.2);
    
    % SNR around max peak from spatial average over the whole face without eyes
        % and mouth
    [goodnessRatio_around_average] = measureSNR_maxPeak(P_gAll, freq_g, 0.2, freqMax_average);    
        
    % ratio of 1st max peak to 2nd max peak
    % find 2nd max peak
    for g = 1:size(P_gAll,2)
        [pks, locs] = findpeaks(P_gAll(:,g),freq_g);

        [pks_sort, idxPeaks] = sort(pks, 'descend');
        secondMaxFreq(g) = freq_g((idxPeaks(2)));

        ratio_1_2(g) = freqMax(g)/secondMaxFreq(g);
    end
    %% Machine learning 

    %% save
    save([fullPath2Save num2str(vidNum) '.mat'])
    disp(num2str(vidNum))
end % for vidNum