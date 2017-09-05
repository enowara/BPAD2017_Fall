function [goodnessRatio_init1] = measureSNR_maxPeak(P_ICA, freq_ICA, beta1, maxFreqRaw)

% compute SNR around the max peak of raw spatially averaged signal -
% frequency peak most likely to be HR 

% input
% Pwhite - fft of mean subtracted and bandpass filtered raw averaged PPG
% freq1
beta1 = 0.2;

% maxFreqRaw is the max peak in the raw signal in Hz

% initialize
goodnessRatio_init1 = [];

% compute SNR around freqMax for each IC from ICA
for k = 1:size(P_ICA,2)
    % find frequency closest to maxFreqRaw
    tmp = abs(freq_ICA-maxFreqRaw);
    [val idx] = min(tmp); %index of closest freq value
    Fclosest = freq_ICA(idx); %closest freq value
    
    freqLow = Fclosest - beta1; % frequency bounds
    freqHigh = Fclosest + beta1;
    indFLow = find(freq_ICA >= freqLow); % indices of those freq bounds
    indFHigh = find(freq_ICA <= freqHigh);  
    singal_ind = intersect(indFLow,indFHigh); % freq indices within the range around max peak
    noise_ind = setdiff((1:length(freq_ICA)), singal_ind); % freq indices outside the range around max peak
    
    areaSignal_k = sum(P_ICA(singal_ind,k));
    areaNoise_k = sum(P_ICA(noise_ind,k));
    goodnessRatio_init1_k = areaSignal_k/areaNoise_k; % save the Goodness ratio for each grid and the corresponding time point
 
    goodnessRatio_init1 = [goodnessRatio_init1; goodnessRatio_init1_k];
end
end