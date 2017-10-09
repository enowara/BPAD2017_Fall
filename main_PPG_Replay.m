% main script calling all functions to:
% read in the video
% use facial landmarks to define ROIs
% compute raw PPG for each ROI
% and save

% read videos and initialize folders to read from
folderMain = '/media/ewa/SH/DatasetsAntiSpoof/ReplayAttackDirectories/';
folderReal_Alll = {'train/real/', 'test/real/', 'devel/real/'};
folderAttackf_All = {'train/attack/fixed/', 'test/attack/fixed/', 'devel/attack/fixed/'};  
folderAttackh_All = {'train/attack/hand/', 'test/attack/hand/', 'devel/attack/hand/'};

DlibFolder = {'IDAP1stFrameNew', 'IDAP1stFrameNewTest', 'IDAP1stFrameNewDevel'};

datte = '10-03';
saveLiuFolder = ['LiuReplay/' datte '/'];
mkdir(saveLiuFolder)

for f = [1:2]
    NameListAll = [];
    S = [];
    Mlist = []; % combine S and Mlist matrices for each train, test, devel folder
% combine from train, test, devel and split by types of attacks 
    for FF = 1%:3
        folderReal = folderReal_Alll{FF};
        folderAttackf = folderAttackf_All{FF};
        folderAttackh = folderAttackh_All{FF};

    %  for f = 1:3
         S_init = [];
         Mlist_init = [];

        if f == 1
            folderEnd = folderReal;
        end
        if f == 2
            folderEnd = folderAttackf;

        end
        if f == 3
            folderEnd = folderAttackh;
        end
        fileNameList = dir([[folderMain folderEnd] ['*' '.mov']]); %

        clear imgCells
        
        for i =1:length(fileNameList)
            imgCells{i} = fileNameList(i).name;  
        end
    
        [cs,index] = sort_nat(imgCells,'ascend');
        img_names = cs;
        
        % save all video names to later choose tr and ts sets with specific
        % set ups
        if f == 1
            NameListAll = [NameListAll; fileNameList];
            
        elseif f == 2 
            NameListAll = [NameListAll; fileNameList];
            
        elseif f == 3
            NameListAll = [NameListAll; fileNameList];
            
        end
            
       for  m = 58:60%1:3%length(fileNameList)
%         try
            vidName = img_names{m};       
            % read in the videos
            v = VideoReader([folderMain folderEnd vidName]);
            videoLength = v.Duration;
            videoRate = v.FrameRate;
            numFrame = videoLength*videoRate;
            width = v.Width;
            height = v.Height; 
            Fps = v.FrameRate;

            frames = read(v);

            vg = frames(:,:,2,:);
            vg = permute(vg,[1,2,4,3]);   
        t=1; % first frame
            firstFrame = vg(:,:,t);
        load(['/media/ewa/Data/PreliminaryResultsToCleanUp/FromBPADCameraVitals2016/Data/' DlibFolder{FF} '/' num2str(f) 'Dlib/dLib-' vidName '.png.mat'])

            firstPoints = pointsResized;
    
    %% load 68 points and add forehead and face mask from it - no eyes or mouth
    % if facial landmarks are only detected for the first frame, only feed in
    % the first frame to define the mask and points
    
    % add the forehead ROI
    [faceMask, firstPoints_augmented] = face_points_mask(firstPoints, firstFrame);

    % TODO: learn where the forehead points should lie using simple
    % regression
    %% track points
    vis = 0; % if 1 it will display the image being tracked
    % [tracked_points] = tracker(vidSin_out, pointsResizedAll, vis);
    n_tr = 20;
    [tracked_points_mask] = KLTtrackerMASK(vg, faceMask, n_tr, 0);

    %% define ROIs
%     % 3 big ROIs forehead and cheeks, each split into 2 or 3 more
%     [gridPoints]= forehead_LRCheek(tracked_points_mask, pointsResizedAll);
%     % [~, included_x_All_Final, included_y_All_Final] = find_triangle_ROIs(tracked_points, vidSin_out);
% 
%     % [included_x_All_Final, included_y_All_Final] = find_triangle_ROIs2(firstPoints_augmented, tracked_points_mask);
% 
%     
%     % TODO: manually split the face ROI into larger regions of approx same size,
%     % including the forehead
    
    [facialRegions] = generateFacialROIs_F(firstPoints_augmented);   % each cell is each ROI, with forehead

    %% get raw PPG
%     for g = 1:length(gridPoints)
%         raw_PPG{g} = raw_PPG_get_rigid_grid(vg, gridPoints{g}, 20);
%     end
%     raw_PPG_all = raw_PPG_get_rigid_grid(vg, tracked_points_mask, 20);

    
    % TODO: raw_PPG_get_2 compute PPG from each predefined ROI
    % average all pixels inside a given ROI
    PPGraw = [];
    N = size(facialRegions,2);
    for n = 1:N % for each ROI
    
        tempReg = round(facialRegions{n});
        temp = inpolygon(tracked_points_mask(1,:,1), tracked_points_mask(1,:,2), tempReg(:,1), tempReg(:,2));
        tempIDX = find(temp ==1);
        gridROI = tracked_points_mask(:,tempIDX,:); 
        
        if isempty(gridROI)
            PPGraw_mean = zeros(size(vg,1), 1);    % zero if tracked mask has eyes and mouth excluded
        else
            
            [PPGraw_n] = raw_PPG_get(vg, gridROI, n);

            PPGraw_n = PPGraw_n(1:229,:);

            PPGraw_mean = mean(PPGraw_n,2);

            PPGraw =  [PPGraw PPGraw_mean]; % per person
        end
    end
%     clear vg

    %% process raw PPG - subtract the mean and bandpass filter
%     for g = 1:length(gridPoints)
%         PPG_filt{g} = procPPG(raw_PPG{g}, Fps);
%     end
% 
%     [PPG_filt_all] = procPPG(raw_PPG_all, Fps);
    PPG_filt = procPPG(PPGraw, Fps);
    %% fft
    P_gAll = [];
    beta1 = 0.2;
    figure('units','normalized','outerposition',[0 0 1 1])
    for g = 1:size(PPG_filt,2)
        subplot(ceil(sqrt(size(PPG_filt,2))), ceil(sqrt(size(PPG_filt,2))), g)
        % get fft for each ROI
        [freq_g, P_g] = fft_get(PPG_filt(:,g), Fps); % averaged
        plot(freq_g, P_g)
        
        % get SNR around that peak
        [goodnessRatio_init1, freqMax, ~, ~] = measureSNRgrid(P_g, freq_g, beta1);
        
        % get max peak, HR
        HR_g = freqMax*60;
        % get SNR around spatial average peak

        title([num2str(g) 'HR: ' num2str(HR_g) ' SNR: ' num2str(goodnessRatio_init1)])
        
        P_gAll = [P_gAll P_g];
    end
    
        saveas(gcf, [fullPath2Save 'Replay-' datte '-' num2str(f) '-' num2str(m) '-ROIsFFT' '.fig']) 
        [imageData, alpha] = export_fig([fullPath2Save 'Replay-' datte '-' num2str(f) '-' num2str(m) '-ROIsFFT'], '-png', '-q101');
        close
        
%% Plot SNR and max peaks
%  SNRvec = [];
%  HR_vec = [];
%  beta1 = 0.2;
%  for g = 1:size(PPG_filt,2)
%     [freq_g, P_g] = fft_get(PPG_filt(:,g), Fps); % averaged
%     % get SNR around that peak
%     [goodnessRatio_init1, freqMax, ~, ~] = measureSNRgrid(P_g, freq_g, beta1);
%      
%     SNRvec = [SNRvec; goodnessRatio_init1];
%         % get max peak, HR
%     HR_g = freqMax*60;
%         % get SNR around spatial average peak
%     HR_vec = [HR_vec; HR_g];
%  end
%  
%  if f==1
% % plot([1:length(SNRvec)], SNRvec, '.b')
% plot(HR_vec, SNRvec, '.b')
% 
% elseif f ==2
% % plot([1:length(SNRvec)], SNRvec, '.r')
% plot(HR_vec, SNRvec, '.r')
% 
%  end

 
% figure, 
% title(['Replay' num2str(f) ' - ' num2str(m)])
% plot([1:length(SNRvec)], SNRvec, '.')
        
% saveas(gcf, [fullPath2Save 'Replay-' datte '-' num2str(f) '-' num2str(m) '-SNR' '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save 'Replay-' datte '-' num2str(f) '-' num2str(m) '-SNR'], '-png', '-q101');
% close
%     saveas(gcf, [fullPath2Save num2str(vidNum) '_ROIsPPG_' '.fig']) 
%     [imageData, alpha] = export_fig([fullPath2Save num2str(vidNum) '_ROIsPPG_'], '-png', '-q101');
%     close

%     [freq_all, P_all] = fft_get(PPG_filt_all, Fps); % averaged
%     figure, hold on, plot(freq_all, P_all, 'c')

%     saveas(gcf, [fullPath2Save num2str(vidNum) '_average_PPG_' '.fig']) 
%     [imageData, alpha] = export_fig([fullPath2Save num2str(vidNum) '_average_PPG_'], '-png', '-q101');
%     close

    %% reject poor ROIs
        end
       end
    end


%     %% extract features
%     
%     % normalize SNR to some scale
%     % max peak location, equivalent to HR estimate
%     % SNR, equivalent to goodness
%     % for all grids
%     % for averaged PPG
%     
%     % SNR around max peak from spatial average over the whole face without eyes
%         % and mouth
% %     [goodnessRatio_around_average] = measureSNR_maxPeak(P_gAll, freq_g, 0.2, freqMax_average);    
%         
%     % ratio of 1st max peak to 2nd max peak
%     % find 2nd max peak
%     for g = 1:size(P_gAll,2)
%         [pks, locs] = findpeaks(P_gAll(:,g),freq_g);
% 
%         [pks_sort, idxPeaks] = sort(pks, 'descend');
%         secondMaxFreq(g) = freq_g((idxPeaks(2)));
% 
%         ratio_1_2(g) = freqMax(g)/secondMaxFreq(g);
%     end
%     %% Machine learning 
% 
%     %% save
%     save([fullPath2Save num2str(vidNum) '.mat'])
%     disp(num2str(vidNum))
% end % for vidNum