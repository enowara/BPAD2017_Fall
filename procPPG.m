function [PPG_filt1] = procPPG(raw_PPG1, Fps1)
%% debugging
% raw_PPG1 = raw_PPG;
% Fps1 = Fps;

% input:
% raw_PPG1 - raw PPG signal
% Fps - frame rate of the video, necessary to select the right filters

% output:
% PPG_filt1 - filtered and or mean subtracted PPG signal 


%% subtract the mean (time-wise) from each grid ROI
for k = 1:size(raw_PPG1,2) 
    PPG1(:,k) = raw_PPG1(:,k) - mean(raw_PPG1(:,k));
end
%% load appropriate filters according to the frame rate of the video
% Fps1
if Fps1 == 30
%     load('Trial2_Filters_30fps.mat')  % elliptical filter with lower order for high pass - no NaN values
    load('highpass_05_30.mat')
    load('lowpass_5_30.mat')
    bLow = lowpass_5;
    aLow = 1;
    bHigh = highpass_05;
    aHigh = IIR_part;
elseif Fps1 == 25
    load('EwaHighPass.mat')
    load('EwaLowPass.mat')
%     disp('using 25 fps filters')
    bLow = b;
    aLow = 1;
    bHigh = b_i;
    aHigh = a_i;
else
    load('Trial2_Filters_30fps.mat')  % elliptical filter with lower order for high pass - no NaN values
    disp('Passed non-standard 30 fps, using filters for 30 by default')
end
%% filter 
% check if video is long enough to be filtered
if length(PPG1(:,k)) > length(bLow) * 3
for k = 1:size(raw_PPG1,2) 
    PPG_filtLow1(:,k) = filtfilt(bLow, aLow, PPG1(:,k)); %low pass filter  % TODO: in the future make less coefficients so that the video doesn't need to be as long
    PPG_filt1(:,k) = filtfilt(bHigh, aHigh, PPG_filtLow1(:,k)); % high pass filter
    if sum(sum(isnan(PPG_filt1))) > 0
        disp('PPG is NaN. Exiting...')
        break
    end
end

% figure, plot(mean(PPG_filt1,2))
% The length of the input signal x must be more than three times the filter order, defined as max(length(b)-1,length(a)-1). 

else
    disp(['The length of input video must be at least ' num2str(3*length(bLow)) 'frames long'])
end
% disp('not filtering')
% PPG_filt1 = PPG1;
end

% Hd = dfilt.df2sos(SOS, G);             % Create the filter object
% [b,a] = sos2tf(SOS,G);
% 
% for k = 1:size(PPG1,2) 
%     PPGf(:,k) = filtfilt(b, a, PPG1(:,k)); %low pass filter  % TODO: in the future make less coefficients so that the video doesn't need to be as long
% end
% 
% figure, plot(mean(PPGf,2))
