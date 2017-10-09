%CONFIDENTIAL (C) Mitsubishi Electric Research Labs (MERL) 2017 
%Ewa Nowara 
%May 23 2017 
function [goodnessRatio_init2, freqMax, areaSignal] = measureSNRgrid_unitP(P1, freq1, beta1) 
 
% get a raw estimate of the SNR defined as ratio of max peak+/-0.2 to the 
% WHOLE of the spectrum - max SNR=1

% initialize 
goodnessRatio_init2 = []; 
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
%     noise_ind = setdiff((1:length(freq1)), singal_ind); % freq indices outside the range around max peak 
     
    areaSignal_k = sum(P1(singal_ind,k)); 
%     areaNoise_k = sum(P1(noise_ind,k));
    area_whole_spec = sum(P1(:,k)); % area of the whole power spectrum
    goodnessRatio_init2_k = areaSignal_k/area_whole_spec; % save the Goodness ratio for each grid and the corresponding time point 
  
goodnessRatio_init2 = [goodnessRatio_init2; goodnessRatio_init2_k]; 
freqMax = [freqMax; freqMax_k]; 
areaSignal = [areaSignal; areaSignal_k]; 
% areaNoise = [areaNoise; areaNoise_k];  
 
end 
 
end 