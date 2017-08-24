function [PPG_filt, PPG_final, tracked_points, Fps, goodnessRatio_init] = mainGoodness(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end, fullPath2Save, removeSpecular, numGrids, datte, xinput, yinput)
specularThresh = 1000;
% addpath('/homes/nowara/Documents/BioSignalsCode/matlabDocCode/altmany-export_fig-5be2ca4')

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
[vidSin_out, ~, Fps] = read_video(filename, fullPath2File, vid_phot, fileFormat, vid_start, vid_end); % check TODO

% vidSin_out = vidSin_out(:,:,vid_start:end);

if isa(vidSin_out, 'uint8') ~= 1 && isa(vidSin_out, 'uint16') ~= 1
    vidSin_out = uint8(vidSin_out);  % if the video is not uint8, but double, it looks all white, and tracking won't work
end
    %% remove specularities
firstFrame = (vidSin_out(:,:,1));
faceDetector = vision.CascadeObjectDetector();  % initialize Viola Jones face detection, TODO later replace with better face detection
bbox = step(faceDetector, firstFrame);
    
%  figure, imshow(firstFrame,[])
%  pause()
 
if sum(bbox(:)) > 0
    x_init = [bbox(1), bbox(1), (bbox(1)+bbox(3)), (bbox(1)+bbox(3))];
    y_init = [bbox(2), (bbox(2) + bbox(4)), (bbox(2)+bbox(4)), bbox(2)];
else 
    disp('no face detected')
    x_init = xinput;
    y_init = yinput;
    bbox = [x_init(1) y_init(1) (x_init(3) - x_init(1)) (y_init(2) - x_init(1))];
end
% n = numGrids;
% numGrids = 10; % 5 x 5 or so total
n = 75;%round((max(bbox(3), bbox(4)))/numGrids); % size of grid ROI from which to get PPG
epoch_Half = 5; % in seconds
vis = 0; % true=1, if on then tracker will display what the   
    
%     remove the last row and column of grids to make sure the raw PPG
    % computation doesn't go too far beyond the boundary
x = [x_init(1)-n, x_init(2)-n, x_init(3)+n, x_init(4)+n];
y = [(y_init(1)-n), (y_init(2)+n), (y_init(3) +n), (y_init(4)-n)];

if removeSpecular == 1
    [NonSpecImgMask] = removeSpecularFun(firstFrame, specularThresh);  % removeSpecular is all 0! % FIX 

    ROI_initFace = roipoly(firstFrame, x_init, y_init); % logical, binary mask that defines a ROI
    ROInonSpec = NonSpecImgMask.*ROI_initFace;  
else
    ROInonSpec = roipoly(firstFrame, x_init, y_init); % logical, binary mask that defines a ROI
end
[init_gridsFace] = roi_2grid(ROInonSpec, n); % check TODO
%     figure, imshow(ROI_initFace)
%   figure, imshow(ROInonSpec)
%     figure, imshow(firstFrame,[])
%     hold on 
%     plot(init_gridsFace(:,1), init_gridsFace(:,2), '*g')
%     pause(2)
% %     for ii = 1:25
% %         plot(init_gridsFace(ii,1), init_gridsFace(ii,2), '*g')
% %         pause(1)
% %     end
% %     
% % %     plot(init_gridsFace(:,1), init_gridsFace(:,2), '*g')
% %     saveas(gcf, [fullPath2Save '_Grids_' datte '.fig']) 
% %     [imageData, alpha] = export_fig([fullPath2Save '_Grids_' datte], '-pdf', '-transparent', '-q101');
% %     [imageData, alpha] = export_fig([fullPath2Save '_Grids_' datte], '-png', '-q101');
%     close
% 
    ROI_initFace2 = roipoly(vidSin_out(:,:,1), x, y);
if removeSpecular == 1
    ROInonSpec2 = NonSpecImgMask.*ROI_initFace2;
else
    ROInonSpec2 = ROI_initFace2;
end
%     ROInonSpec2 = ROI_initFace2;
%     init_gridsFace2Track = roi_2grid(ROInonSpec2, n); 
    
%     minI = min(vidSin_out(:));
%     maxI = max(vidSin_out(:));
%     vidSin_out_track = ((vidSin_out-minI).*255./(maxI-minI)); % this makes the image saturated
    
    [tracked_points] = tracker(uint8((vidSin_out/4)), init_gridsFace, n, vis); % check other TODO's  % for now track using a single channel just for simplicity
%% recreate ICA grids
% firstFrame = vidSin_out(:,:,vid_start);
% % face ROI 
% % x1 = [252 252 810 810];
% % y1 = [358 1041 1041 358];
% 
%     faceDetector = vision.CascadeObjectDetector();  % initialize Viola Jones face detection, TODO later replace with better face detection
%     bbox = step(faceDetector, firstFrame);
% % % Jason forehead
% % x = [146 146 744 744];
% % y = [123 422 422 123];
% 
% if sum(bbox(:)) > 0
%         x_init = [bbox(1), bbox(1), (bbox(1)+bbox(3)), (bbox(1)+bbox(3))];
%         y_init = [bbox(2), (bbox(2) + bbox(4)), (bbox(2)+bbox(4)), bbox(2)];
% else 
%         disp('no face detected')
% %         break
% end
%     
%     numGrids = 5; % 5 x 5 or so total
%     n = round((max(bbox(3), bbox(4)))/numGrids); % size of grid ROI from which to get PPG
%     epoch_Half = 5; % in seconds
%     vis = 0; % true=1, if on then tracker will display what the   
%     
%     % remove the last row and column of grids to make sure the raw PPG
%     % computation doesn't go too far beyond the boundary
%     x = [x_init(1), x_init(2), x_init(3) , x_init(4)];
%     y = [y_init(1), y_init(2), y_init(3) , y_init(4)];
% %     x = x_init;
% %     y = y_init;
% %     
%     ROI_initFace = roipoly(firstFrame, x_init, y_init); % logical, binary mask that defines a ROI
%     [init_gridsFace] = roi_2grid(ROI_initFace, n); % check TODO
% 
% % %     figure, imshow(ROI_initFace)
%     figure, imshow(firstFrame,[])
%     hold on 
% %     plot(init_gridsFace(:,1), init_gridsFace(:,2), '*g')
% %     for ii = 1:25
% %         plot(init_gridsFace(ii,1), init_gridsFace(ii,2), '*g')
% %         pause(1)
% %     end
% %     
%     plot(init_gridsFace(:,1), init_gridsFace(:,2), '*g')
%     saveas(gcf, [fullPath2Save '_Grids_' datte '.fig']) 
%     [imageData, alpha] = export_fig([fullPath2Save '_Grids_' datte], '-pdf', '-transparent', '-q101');
%     [imageData, alpha] = export_fig([fullPath2Save '_Grids_' datte], '-png', '-q101');
%     close
% 
%     ROI_initFace2 = roipoly(vidSin_out(:,:,1), x, y);
%     init_gridsFace2Track = roi_2grid(ROI_initFace2, n); 
%     
%     [tracked_points] = tracker(vidSin_out, init_gridsFace2Track, n, vis); % check other TODO's  % for now track using a single channel just for simplicity
%% PPG computation
% numPointsExpectedFromPPG = (sqrt(size(tracked_points,2)) - 1)^2
if removeSpecular == 1
    [raw_PPG] = ignoreROI_raw_PPG(vidSin_out, tracked_points, n, specularThresh);
else
    [raw_PPG] = get_raw_PPG(vidSin_out, tracked_points, n); % Add a condition to ignore time points and grids which are exactly 0
end
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


%% Goodness
[thresh_AmpAbs1] = setAmpThresh(PPG_filt);

epoch_Half = 5; % in seconds, duration of each time epoch, window within which goodness is computed is epoch*2
% overlap_inint = epoch_Half;
thresh_AmpRel = 8;
% thresh_AmpAbs = 80000;
betaFreq = 0.2;
thresh_Goodn = 0.2;

[goodnessRatio_init] = measureSNRgrid(P_raw, freq, thresh_Goodn);
% 
% figure,
% for k =1:size(P_raw,2)
%     subplot(ceil(sqrt(size(P_raw,2))), ceil(sqrt(size(P_raw,2))), k)
%     plot(freq, P_raw(:,k))
%     [val, argF] = max(P_raw(:,k));
%     freqMax = freq(argF);
%     HR_est_k = freqMax*60;
%     xticks(0:1:15)
% %     plot in the title - SNR and est HR
%     title(['SNR: ' num2str(goodnessRatio_init(k)) '  HR: ' num2str(HR_est_k)])
% end

[PPG_final, goodness_RatioVec] = finalPPG(PPG_filt, epoch_Half, Fps, thresh_AmpAbs1, betaFreq, thresh_Goodn);
% figure, 
% hold on
% plot(PPG_final)
% title('filtered averaged PPG')
% xlabel('time [frames]')
% ylabel('amplitude')
% saveas(gcf, [fullPath2Save '_finalPPG_' datte '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_' datte], '-pdf', '-transparent', '-q101');
% [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_' datte], '-png', '-q101');
% close

% figure,
% hold on
% plot(PPG_filt(:,k))
% goodness_RatioVec - each row is a grid ROI value, each column is a time
% window
[freqFinal, PPG_final_spectrum] = frequencyPlot(PPG_final,Fps);   % some values are NaN

% figure,
% hold on
% plot(P_raw(:,k))

% figure, 
% hold on
% plot(freqFinal, PPG_final_spectrum)
% xticks(0:1:15)
% title('final PPG fft')
% xlabel('frequency [Hz]')
% ylabel('[power spectrum')
% saveas(gcf, [fullPath2Save '_finalPPG_FFT_' datte '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_FFT_' datte], '-pdf', '-transparent', '-q101');
% [imageData, alpha] = export_fig([fullPath2Save '_finalPPG_FFT_' datte], '-png', '-q101');
% close

[goodnessRatio_init] = measureSNRgrid(P_raw, freq, thresh_Goodn); % SNR before goodness metric
% [goodnessRatio_initOLD] = measureSNR(mean(P_raw,2), freq, thresh_Goodn);
% mean(goodnessRatio_init) and goodnessRatio_initOLD are different values
[goodnessRatio] = measureSNR(PPG_final_spectrum, freqFinal, thresh_Goodn); % SNR after goodness metric

%% plot figures

save([fullPath2Save '_goodness_' datte '.mat']) % save everything

% t = 1;
% visualize_goodness(goodness_RatioVec, goodnessRatio_init, n, tracked_points, firstFrame, fullPath2Save, datte, init_gridsFace, t);
% saveas(gcf, [fullPath2Save 'goodnessWeights' datte '.fig']) 
% [imageData, alpha] = export_fig([fullPath2Save 'goodnessWeights' datte], '-pdf', '-transparent', '-q101');
% [imageData, alpha] = export_fig([fullPath2Save 'goodnessWeights' datte], '-png', '-q101');
% close

end
