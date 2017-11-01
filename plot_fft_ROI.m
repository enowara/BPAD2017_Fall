figure, 

for k = 1:size(P_gAll,2)
    subplot(ceil(sqrt(size(P_gAll,2))), ceil(sqrt(size(P_gAll,2))), k)
    plot(freq_g, P_gAll(:,k))
end

figure, 

for k = 1:size(PPG_filt,2)
    subplot(ceil(sqrt(size(PPG_filt,2))), ceil(sqrt(size(PPG_filt,2))), k)
    plot(PPG_filt(:,k))
end

load('/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/Live_vs_Fake_ROI/10-08/3DMAD--3-82.mat')