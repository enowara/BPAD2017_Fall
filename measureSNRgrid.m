function [goodnessRatio_init1, freqMax, areaSignal, areaNoise] = measureSNRgrid(P1, freq1, beta1)

% get a raw estimate of the SNR defined as ratio of max peak+/-0.2 to the
% rest of the spectrum - to see if the method is able to get a rough
% estimate of the PPG signal

% initialize
goodnessRatio_init1 = [];
freqMax = [];
areaSignal = [];
areaNoise = []; 

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
    goodnessRatio_init1_k = areaSignal_k/areaNoise_k; % save the Goodness ratio for each grid and the corresponding time point
 
goodnessRatio_init1 = [goodnessRatio_init1; goodnessRatio_init1_k];
freqMax = [freqMax; freqMax_k];
areaSignal = [areaSignal; areaSignal_k];
areaNoise = [areaNoise; areaNoise_k]; 

end

end
   