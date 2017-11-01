%CONFIDENTIAL (C) Mitsubishi Electric Research Labs (MERL) 2017
%Ewa Nowara
%May 18 2017

% add back to output PPG_final

function [PPG_filt, tracked_points, Fps, goodnessRatio_init, freq, P_rawMean, P_raw] = ...
    mainGoodness2(filename, fullPath2File, vid_phot, fileFormat, vid_start, ...
    vid_end, fullPath2Save, removeSpecular, numGrids, datte, xinput, yinput, specularThresh, ...
    numFrame, landmarks, landmark_path)


% specularThresh = 1000;
% addpath('/homes/nowara/Documents/BioSignalsCode/matlabDocCode/altmany-export_fig-5be2ca4')
addpath('/media/ewa/SH/MERL_research/BioSignalsCode/matlabDocCode/sort_nat');
% saveFolder = '/homes/nowara/Documents/BioSignalsResults/PreliminaryResults/AdjustedExposure_07_06/';
% saveFolder = '/homes/nowara/Documents/BioSignalsResults/PreliminaryResults2/3_IRsources_07_13_thresh250/';

% % saveFolder = '../../BioSignalsResults/PreliminaryResults/goodness_ROIs/';
% mkdir(saveFolder);
% datte = '07_13';

% filename = '';
% fullPath2File = '/homes/nowara/Documents/Datasets/MyIRDataGrasshopper/3lightIR_lowExposure/';
% vid_phot = 'phot';
% fileFormat = '.pgm';
% vid_start = 1; % remove the first and last 20 sec
% vid_end = 0;

% 
% removeSpecular = 1;
% specularThresh = 250;


% for f = %1:4
%     close all
% if f == 1
% filename = '';
% fullPath2File = '/homes/nowara/Documents/Datasets/MMSE-HR/first 10 subjects 2D/F022/T8/'; %'/homes/nowara/Documents/Datasets/MMSE-HR/first 10 subjects 2D/F013/T1/';
% vid_phot = 'phot';
% fileFormat = '.jpg';
% vid_start = 1;
% vid_end = 310;
% 
% elseif f == 2
% filename = '';
% fullPath2File = '/homes/nowara/Documents/Datasets/MMSE-HR/first 10 subjects 2D/M010/T10/'; %'/homes/nowara/Documents/Datasets/MMSE-HR/first 10 subjects 2D/F013/T1/';
% vid_phot = 'phot';
% fileFormat = '.jpg';
% vid_start = 1;
% vid_end = 0;
% 
% elseif f == 3
% filename = '';
% fullPath2File = '/homes/nowara/Documents/Datasets/distancePPG/stationaryData/UID_002/lighting condition/EID_1/';
% vid_phot = 'phot';
% fileFormat = '.pgm';
% vid_start = 1;
% vid_end = 0;
% 
% elseif f == 4
% filename = '';
% fullPath2File = '/homes/nowara/Documents/Datasets/distancePPG/motion/UID001/MotionFinal/EID004/';
% vid_phot = 'phot';
% fileFormat = '.pgm';
% vid_start = 1;
% vid_end = 0;
% end

% % fullPath2Save = [saveFolder 'IR7_notSpec'];
% fullPath2Save = [saveFolder];

%% read in RGB or IR video
 % don't provide the end if you want to read in the whole video
[vidSin_out, ~, Fps] = read_video(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end, numFrame); % check TODO

% vidSin_out = vidSin_out(:,:,vid_start:end);

if isa(vidSin_out, 'uint8') ~= 1 && isa(vidSin_out, 'uint16') ~= 1
    vidSin_out = uint8(vidSin_out);  % if the video is not uint8, but double, it looks all white, and tracking won't work
end
    %% remove specularities
firstFrame = (vidSin_out(:,:,1));

% if no facial landmarks provided, use face detection
if landmarks == 0
    faceDetector = vision.CascadeObjectDetector();  % initialize Viola Jones face detection, TODO later replace with better face detection
    bbox = step(faceDetector, firstFrame);
    %     
    % %  figure, imshow(firstFrame,[])
    % %  pause()
    %  
    if sum(bbox(:)) > 0
        x_init = [bbox(1), bbox(1), (bbox(1)+bbox(3)), (bbox(1)+bbox(3))];
        y_init = [bbox(2), (bbox(2) + bbox(4)), (bbox(2)+bbox(4)), bbox(2)];
    else 
    %     disp('no face detected')
        x_init = xinput;
        y_init = yinput;
    %     bbox = [x_init(1) y_init(1) (x_init(3) - x_init(1)) (y_init(2) - x_init(1))];
    end
    % n = numGrids;
    % numGrids = 10; % 5 x 5 or so total
    % n = 40;%round((max(bbox(3), bbox(4)))/numGrids); % size of grid ROI from which to get PPG

    fw = max(x_init)-min(x_init); % face ROI width
    fh = max(y_init)-min(y_init); % height

    numPnts = (sqrt(numGrids)+1)^2;  % num of ROIs is (sqrt(numPnts) - 1)^2

    % numPnts = numGrids;

    n1 = round(fh/sqrt(numPnts));
    n2 = round(fw/sqrt(numPnts)); % smaller

    epoch_Half = 5; % in seconds
    vis = 0; % true=1, if on then tracker will display what the   

    %     remove the last row and column of grids to make sure the raw PPG
        % computation doesn't go too far beyond the boundary
    % x = [x_init(1), x_init(2), x_init(3)+n, x_init(4)+n];
    % y = [(y_init(1)), (y_init(2)+n), (y_init(3) +n), (y_init(4))];

    if removeSpecular == 1
        [NonSpecImgMask] = removeSpecularFun(firstFrame, specularThresh);  % removeSpecular is all 0! % FIX 

        ROI_initFace = roipoly(firstFrame, x_init, y_init); % logical, binary mask that defines a ROI
        ROInonSpec = NonSpecImgMask.*ROI_initFace;  
    else
        ROInonSpec = roipoly(firstFrame, x_init, y_init); % logical, binary mask that defines a ROI
    end
    [init_gridsFace] = roi_2grid(ROInonSpec, n1, n2); % check TODO
    
    if isa(vidSin_out, 'uint16')
        [tracked_points] = tracker(uint8((vidSin_out/4)), init_gridsFace, vis); % check other TODO's  % for now track using a single channel just for simplicity
    else
        [tracked_points] = tracker(vidSin_out, init_gridsFace, vis); % check other TODO's  % for now track using a single channel just for simplicity
    end
    
    % but if landmarks are provided use their location to define ROIs
elseif landmarks == 1 
    
    % load landmarks,     % convert to correct format
    addpath('/media/ewa/SH/MERL_research/BioSignalsCode/FacialMotion/')
    [x_pnts, y_pnts] = plot_landmarks_on_img(landmark_path, fullPath2Save);
    firstPoints1 = [x_pnts' y_pnts'];
    
    % define ROIs
    addpath('/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Code/BPAD2017_Fall/')
    [finalImg, firstPoints_augmented1] = face_points_mask(firstPoints1, firstFrame);
    [facialRegions] = generateFacialROIs_2(firstPoints_augmented1);
    % plot ROIs on the face and landmarks
    
    figure, imshow(firstFrame,[])
    hold on
    for ii = 1:length(x_pnts)
    plot(x_pnts(ii), y_pnts(ii), '*')
%     pause()
    end
    
    
for i = 1:length(facialRegions)
    pnts_plot = facialRegions{i};
    plot(pnts_plot(:,1), pnts_plot(:,2), 'LineWidth', 2)
%     title(num2str(i))
%     pause()
end
%     pause()
saveas(gcf, [fullPath2Save 'facial_ROIs' datte '.fig']) 
[imageData, alpha] = export_fig([fullPath2Save 'facial_ROIs' datte], '-pdf', '-transparent', '-q101');
[imageData, alpha] = export_fig([fullPath2Save 'facial_ROIs' datte], '-png', '-q101');
close


%% try tracking each facial ROI separately because they have different shape and size
% then combine the tracked parts from each ROI
tracked_points = [];
for i = 1:length(facialRegions)
    if isa(vidSin_out, 'uint16')
        [tracked_points_init{i}] = tracker(uint8((vidSin_out/4)), facialRegions{i}, vis); % check other TODO's  % for now track using a single channel just for simplicity
    else
        [tracked_points_init{i}] = tracker(vidSin_out, facialRegions{i}, vis); % check other TODO's  % for now track using a single channel just for simplicity
    end
    
    % combine
    
    pnts = facialRegions{i}; % points defining the ROI
    mask_i = poly2mask(pnts(:,1), pnts(:,2), size(firstFrame,1), size(firstFrame,2));

    mask_All{i} = mask_i; % save each ROI as a mask to use for PPG computations
    
    tracked_points = cat(2, tracked_points, (tracked_points_init{i}));
    
    
end
end

%% PPG computation
% numPointsExpectedFromPPG = (sqrt(size(tracked_points,2)) - 1)^2

% right now have one too many rows and columns, so 25 grids instead of 16
if removeSpecular == 1
    [raw_PPG] = ignoreROI_raw_PPG(vidSin_out, tracked_points, n1, n2, specularThresh, numGrids);
else
%     [raw_PPG] = get_raw_PPG(vidSin_out, tracked_points, n1, n2, numGrids); % Add a condition to ignore time points and grids which are exactly 0
%     [raw_PPG] = get_raw_PPG_per_pixel(vidSin_out, tracked_points, n1, n2, numGrids); % Add a condition to ignore time points and grids which are exactly 0
    [raw_PPG] = get_raw_PPG_ROI(vidSin_out, mask_All); % Add a condition to ignore time points and grids which are exactly 0


end



% for now just remove 0 vectors, but later have a better way of only
% computing correct ROIs
zero_vec_raw_PPG = find(raw_PPG(1,:) == 0);
vec_keep_raw_PPG = setdiff([1:size(raw_PPG,2)], zero_vec_raw_PPG);

raw_PPG = raw_PPG(:,vec_keep_raw_PPG);
% subtract the mean and bandpass filter
[PPG_filt] = procPPG(raw_PPG, Fps);

% size(PPG_filt)
clear vidSin_out 

% tic; savefig(gcf, '/tmp/testfig.fig', 'compact'); toc;
% figure, 
% % figure('units','normalized','outerposition',[0 0 1 1]),
% hold on
% plot(mean(raw_PPG,2))
% title('raw averaged PPG')
% xlabel('time [frames]')
% ylabel('amplitude')
% saveas(gcf, [fullPath2Save '_rawPPG_' datte '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save '_rawPPG_RGB_' datte], '-pdf', '-transparent', '-q101');
% [imageData, alpha] = export_fig([fullPath2Save '_rawPPG_RGB_' datte], '-png', '-q101');
% close
% 
% figure, 
% hold on
% plot(mean(PPG_filt,2))
% title('filtered averaged PPG')
% xlabel('time [frames]')
% ylabel('amplitude')
% saveas(gcf, [fullPath2Save '_filtPPG_' datte '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save '_filtPPG_RGB_' datte], '-pdf', '-transparent', '-q101');
% [imageData, alpha] = export_fig([fullPath2Save '_filtPPG_RGB_' datte], '-png', '-q101');
% close

% % frequency estimate from fft
[freq, P_raw] = frequencyPlotGrid(PPG_filt, Fps);  % 1 2 10 20 200
[freq, P_rawMean] = frequencyPlot(PPG_filt, Fps);  % 1 2 10 20 200

% figure, 
% hold on
% plot(freq, P_rawMean)
% xticks(0:1:15)
% title('filtered averaged fft')
% xlabel('frequency [Hz]')
% ylabel('[power spectrum')
% saveas(gcf, [fullPath2Save '_filtPPG_FFT_' datte '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save '_filtPPG_FFT_' datte], '-pdf', '-transparent', '-q101');
% [imageData, alpha] = export_fig([fullPath2Save '_filtPPG_FFT_' datte], '-png', '-q101');
% close
% 


% %% Goodness
% [thresh_AmpAbs1] = setAmpThresh(PPG_filt);
% 
% epoch_Half = 5; % in seconds, duration of each time epoch, window within which goodness is computed is epoch*2
% % overlap_inint = epoch_Half;
% thresh_AmpRel = 8;
% % thresh_AmpAbs = 80000;
% betaFreq = 0.2;
thresh_Goodn = 0.2;
% 
[goodnessRatio_init] = measureSNRgrid(P_raw, freq, thresh_Goodn);
% % 
% % figure,
% % for k =1:size(P_raw,2)
% %     subplot(ceil(sqrt(size(P_raw,2))), ceil(sqrt(size(P_raw,2))), k)
% %     plot(freq, P_raw(:,k))
% %     [val, argF] = max(P_raw(:,k));
% %     freqMax = freq(argF);
% %     HR_est_k = freqMax*60;
% %     xticks(0:1:15)
% % %     plot in the title - SNR and est HR
% %     title(['SNR: ' num2str(goodnessRatio_init(k)) '  HR: ' num2str(HR_est_k)])
% % end
% 
% [PPG_final, goodness_RatioVec] = finalPPG(PPG_filt, epoch_Half, Fps, thresh_AmpAbs1, betaFreq, thresh_Goodn);
% % figure, 
% % hold on
% % plot(PPG_final)
% % title('filtered averaged PPG')
% % xlabel('time [frames]')
% % ylabel('amplitude')
% % saveas(gcf, [fullPath2Save '_finalPPG_' datte '.fig']) 
% % [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_' datte], '-pdf', '-transparent', '-q101');
% % [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_' datte], '-png', '-q101');
% % close
% 
% % figure,
% % hold on
% % plot(PPG_filt(:,k))
% % goodness_RatioVec - each row is a grid ROI value, each column is a time
% % window
% [freqFinal, PPG_final_spectrum] = frequencyPlot(PPG_final,Fps);   % some values are NaN
% 
% % figure,
% % hold on
% % plot(P_raw(:,k))
% 
% % figure, 
% % hold on
% % plot(freqFinal, PPG_final_spectrum)
% % xticks(0:1:15)
% % title('final PPG fft')
% % xlabel('frequency [Hz]')
% % ylabel('[power spectrum')
% % saveas(gcf, [fullPath2Save '_finalPPG_FFT_' datte '.fig']) 
% % [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_FFT_' datte], '-pdf', '-transparent', '-q101');
% % [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_FFT_' datte], '-png', '-q101');
% % close
% 
% [goodnessRatio_init] = measureSNRgrid(P_raw, freq, thresh_Goodn); % SNR before goodness metric
% % [goodnessRatio_initOLD] = measureSNR(mean(P_raw,2), freq, thresh_Goodn);
% % mean(goodnessRatio_init) and goodnessRatio_initOLD are different values
% [goodnessRatio] = measureSNR(PPG_final_spectrum, freqFinal, thresh_Goodn); % SNR after goodness metric
% 
% %% plot figures
% 
save([fullPath2Save '_goodness_' datte '.mat']) % save everything
% 
% % t = 1;
% % visualize_goodness(goodness_RatioVec, goodnessRatio_init, n, tracked_points, firstFrame, fullPath2Save, datte, init_gridsFace, t);
% % saveas(gcf, [fullPath2Save 'goodnessWeights' datte '.fig']) 
% % [imageData, alpha] = export_fig([fullPath2Save 'goodnessWeights' datte], '-pdf', '-transparent', '-q101');
% % [imageData, alpha] = export_fig([fullPath2Save 'goodnessWeights' datte], '-png', '-q101');
% % close

end
