% compute goodness SNR over time for each ROI separately and over time. 
% Goodness SNR is defined as ratio of max peak+/-0.2 to the
% rest of the spectrum

% Input: 
% pulseWaveform - time PPG signal vector T X 1
% beta1 - bin size around max peak to find SNR in freq
% timeWindow - time window to window the signal
% Fps - frame rate of video

% Output: 
% goodnessRatio_time_aver2 - goodness SNR for each ROI for each time stamp
% freqMax_time2 - frequency where max peak occured for each ROI for each
% time stamp

function [goodnessRatio_time_aver, goodnessRatio_init1_time, freqMax_time] = measureSNRgrid_over_time(pulseWaveform, beta1, timeWindow, Fps)

    % get a raw estimate of the SNR  - to see if the method is able to get a rough
    % estimate of the PPG signal

    % initialize
    goodnessRatio_init1_time= [];
    freqMax_time = [];
%     areaSignal_time = [];
%     areaNoise_time = []; 

    for tt = floor(timeWindow/2)+1:(size(pulseWaveform,1)-floor(timeWindow/2))
        % initialize
        goodnessRatio_init1 = [];
        freqMax = [];
%         areaSignal = [];
%         areaNoise = []; 
    
        windowedPulse = pulseWaveform(tt - floor(timeWindow/2):tt+floor(timeWindow/2), :); % if overlap - center around the element of interest, move by 1 and keep window of 150

        % take fft
        % n = 2^(nextpow2(size(windowedPulse,1))); % specify the length of fft
        [freq1, P1] = frequencyPlotGrid(windowedPulse, Fps);

        for k = 1:size(P1,2)
            [valF, indF] = max(P1(:,k)); % max spectrum value location - freq bin
            freqMax_k = freq1(indF); % value of max freq

            freqLow = freqMax_k - beta1; % frequency bounds
            freqHigh = freqMax_k + beta1;
            indFLow = find(freq1 >= freqLow); % indices of those freq bounds
            indFHigh = find(freq1 <= freqHigh);  
            singal_ind = intersect(indFLow,indFHigh); % freq indices within the range around max peak
            noise_ind = setdiff((1:length(freq1)), singal_ind); % freq indices outside the range around max peak

            areaSignal_k = sum(P1(singal_ind,k));
            areaNoise_k = sum(P1(noise_ind,k));
            goodnessRatio_init1_k = areaSignal_k/(areaNoise_k); % save the Goodness ratio for each grid and the corresponding time point

        goodnessRatio_init1 = [goodnessRatio_init1; goodnessRatio_init1_k];
        freqMax = [freqMax; freqMax_k];
%         areaSignal = [areaSignal; areaSignal_k];
%         areaNoise = [areaNoise; areaNoise_k]; 

        end
        goodnessRatio_init1_time= [goodnessRatio_init1_time goodnessRatio_init1];
        freqMax_time = [freqMax_time freqMax];
%         areaSignal_time = [areaSignal_time areaSignal];
%         areaNoise_time = [areaNoise_time areaNoise];
    end

    goodnessRatio_time_aver = mean(goodnessRatio_init1_time,1);
    
end
