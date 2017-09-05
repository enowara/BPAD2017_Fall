function [goodnessRatio_init1, freqMax, areaSignal, areaNoise] = measureSNR(P1, freq1, beta1)

% get a raw estimate of the SNR defined as ratio of max peak+/-0.2 to the
% rest of the spectrum - to see if the method is able to get a rough
% estimate of the PPG signal

    [valF, indF] = max(P1); % max spectrum value location - freq bin
    freqMax = freq1(indF); % value of max freq
    
    freqLow = freqMax - beta1; % frequency bounds
    freqHigh = freqMax + beta1;
    indFLow = find(freq1 >= freqLow); % indices of those freq bounds
    indFHigh = find(freq1 <= freqHigh);  
    singal_ind = intersect(indFLow,indFHigh); % freq indices within the range around max peak
    noise_ind = setdiff((1:length(freq1)), singal_ind); % freq indices outside the range around max peak
    
    areaSignal = sum(P1(singal_ind));
    areaNoise = sum(P1(noise_ind));
    goodnessRatio_init1 = areaSignal/(areaNoise); % save the Goodness ratio for each grid and the corresponding time point
 


 
   