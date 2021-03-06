% main script calling all functions to:
% read in the video
% use facial landmarks to define ROIs
% compute raw PPG for each ROI
% and save


%% initialize
filename =''; %'01_01_01.avi';
vid_phot = 'phot'; %'vid';
fileFormat = '.png';% '';


mainFolderVids = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixedNotxt/';
mainFolderPnts = '/media/ewa/SH/DatasetsAntiSpoof/EwaPPGdataCollection/NewerHandvsFixed/';

    datte = '10_10';
    fullPath2Save = ['/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/' ...
        'Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/' datte '/'];
    mkdir(fullPath2Save)

vidList = dir(mainFolderVids);


for vidNum = 3:length(vidList)% [4:6, 8:length(vidList)]
    
    vidName = vidList(vidNum).name; % EwaLiveCamFixed/cam1/';
    fullPath2File = [mainFolderVids vidName '/cam1/'];
    pointsFile = [mainFolderPnts vidName '.txt'];


    addpath('/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Code/temp_helper_functions/altmany-export_fig-5be2ca4/');
    
    %% split videos into shorter time windows
    
    % first check how long each video is
    vid_length = length(dir(fullPath2File));
    tim_win = 10*30;
    counter = 0;
    for tt = 1:tim_win:vid_length-tim_win
        counter = counter+1;
        vid_start = tt;
        vid_finish = tt+tim_win - 1;%[]; % remove this many frames from the end of the video
        vid_end = vid_length - tim_win - vid_start - 1;
        %% read video 
        [vidSin_out, ~, Fps] = read_video(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end);

        % %% load landmarks
        img_names = 'frame_00000.png';

        [pointsResizedAll] = dlib2FacialPoints(fullPath2File,img_names, pointsFile);
    
        firstPoints = pointsResizedAll;
        firstFrame = vidSin_out(:,:,1);
        %% load 68 points and add forehead and face mask from it - no eyes or mouth
        % if facial landmarks are only detected for the first frame, only feed in
        % the first frame to define the mask and points

        [faceMask, firstPoints_augmented] = face_points_mask(firstPoints, firstFrame);

     %% track points
        vis = 0; % if 1 it will display the image being tracked
        % [tracked_points] = tracker(vidSin_out, pointsResizedAll, vis);
        n_tr = 20;
        [tracked_points_mask] = KLTtrackerMASK(vidSin_out, faceMask, n_tr, 0);

        %% define ROIs
        [facialRegions] = generateFacialROIs_2(firstPoints_augmented);   % each cell is each ROI, with forehead

        %% get raw PPG
  
        PPGraw = [];
        N = size(facialRegions,2);
        for n = 1:N % for each ROI
    
            tempReg = round(facialRegions{n});
            temp = inpolygon(tracked_points_mask(1,:,1), tracked_points_mask(1,:,2), tempReg(:,1), tempReg(:,2));
            tempIDX = find(temp ==1);
            gridROI = tracked_points_mask(:,tempIDX,:); 

            if isempty(gridROI)
                PPGraw_mean = zeros(size(vidSin_out,1), 1);    % zero if tracked mask has eyes and mouth excluded
            else

                [PPGraw_n] = raw_PPG_get(vidSin_out, gridROI, n);

    %             PPGraw_n = PPGraw_n(1:229,:);

                PPGraw_mean = mean(PPGraw_n,2);

                PPGraw =  [PPGraw PPGraw_mean]; % per person
            end
        end
%     clear vg
%% process raw PPG - subtract the mean and bandpass filter

        PPG_filt = procPPG(PPGraw, Fps);
    
        %% extract features from each ROI
        P_gAll = [];
        SNR_goodness = [];
        SNR_2 = [];
        HR_vec = [];
        beta1 = 0.2;
    %     figure('units','normalized','outerposition',[0 0 1 1])
        for g = 1:size(PPG_filt,2)
    %         subplot(ceil(sqrt(size(PPG_filt,2))), ceil(sqrt(size(PPG_filt,2))), g)
            % get fft for each ROI
            [freq_g, P_g] = fft_get(PPG_filt(:,g), Fps); 
    %         plot(freq_g, P_g)

            % get SNR goodness around that peak
            [goodnessRatio_init1, freqMax, ~, ~] = measureSNRgrid(P_g, freq_g, beta1);

            % get SNR of max peak vs whole spectrum
            [goodnessRatio_init2, freqMax2, ~] = measureSNRgrid_unitP(P_g, freq_g, beta1);

            % get max peak, HR
            HR_g = freqMax*60;
            % get SNR around spatial average peak

    %         title([num2str(g) 'HR: ' num2str(HR_g) ' SNR: ' num2str(goodnessRatio_init1)])

            P_gAll = [P_gAll P_g];  % feature 0

            % SNR - goodness, max peak over rest of spectrum
            SNR_goodness = [SNR_goodness; goodnessRatio_init1]; % feature 1 
            % SNR - max=1, max peak over whole spectrum
            SNR_2 = [SNR_2; goodnessRatio_init2];  % feature 2

            HR_vec = [HR_vec; HR_g]; % feature 3
        end
    
    % find median of HR from different ROIs or find max peak of spat av
    % face signal?
    
    % med HR val from all ROIs
        HR_med = median(HR_vec);
        diff_HR_med = HR_vec - HR_med; % feature 4
        % this difference vec should have low values for 
        % facial ROIs which have a PPG signal assuming HR_med captured the
        % desired PPG

        % HR from spat av face PPG
        PPG_ave = mean(PPG_filt,2);
        [freq_ave, P_ave] = fft_get(PPG_ave, Fps);

        [~, max_idx] = max(P_ave);
        max_freq_ave = freq_ave(max_idx);
        HR_ave = max_freq_ave*60;

        diff_HR_ave = HR_vec - HR_ave; % feature 5
    
        clear vidSin_out firstFrame faceMask
            % save everything?
        save([fullPath2Save  '/' 'EwaData-'  '-' num2str(vidNum) '-' num2str(counter) '.mat'])
        disp(['processed - ' num2str(vidNum) '-' num2str(counter)])
    end % for t windowing
end % for vidNum