  % plot features / patterns present in live vs attack faces

% folderResults = '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/';
% load([folderResults datte '/' '/EwaData-' '-' num2str(f) '-' num2str(m) '.mat'])
% datte = '10-10';

% cd '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/';
% cd '10_10/'
% '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/';
cd '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/Live_vs_Fake_ROI/';
cd '10-08/'

%% SNR_goodness
figure,
hold on
% title('SNR goodness of each ROIs HR') 
% legend('live', 'attack')
xlabel('HR of each ROI')
ylabel('SNR goodness')
c1 = 0;
c2 = 0;
for f = 1:3
    for m = 1:85
%         subplot(3,2,m)
        title('live vs attack handheld')
        hold on
        % load HR_vec, SNR_goodness
        load(['3DMAD-' '-' num2str(f) '-' num2str(m) '.mat'], 'HR_vec', 'SNR_goodness')
        if f == 1 || f== 2 
            plot(HR_vec, SNR_goodness, '*b')
            c1 = c1+1;
        elseif f == 3
            plot(HR_vec, SNR_goodness, '*r')
            c2 = c2+1;
        end
    end
end
% save % fig
% close


%% HR_vec vs SNR_2
figure,
hold on
title('SNR unity of each ROIs HR') 
% legend('live', 'attack')
xlabel('HR of each ROI')
ylabel('SNR unity')
for f = 1:3
    for m = 1:85
%         subplot(3,2,m)
        hold on
        % load HR_vec, SNR_2
        load(['3DMAD-' '-' num2str(f) '-' num2str(m) '.mat'], 'HR_vec', 'SNR_2')
        if  f == 1 || f == 2
            plot(HR_vec, SNR_2, '*b')
            c1 = c1+1;
        elseif f == 3
            plot(HR_vec, SNR_2, '*r')
            c2 = c2+1;
        end
    end
end
% save % fig
% close
%% diff_HR_med over facial ROIs
figure,
hold on
title('difference between median ROI HR and ROI HR')
% legend('live', 'attack')
xlabel('each ROI')
ylabel('difference between HR ROI and HR ROI median')
for f = 1:3
    for m = 1:85
        % load diff_HR_med
%         subplot(3,2,m)
        hold on
        load(['3DMAD-' '-' num2str(f) '-' num2str(m) '.mat'], 'diff_HR_med')
        if f == 1 || f == 2
            plot([1:length(diff_HR_med)], diff_HR_med, '*b')
            c1 = c1+1;
        elseif f == 3
            plot([1:length(diff_HR_med)], diff_HR_ave, '*r')
            c2 = c2+1;
        end
    end
end
% save % fig
% close
%% diff_HR_ave over facial ROIs

figure,
hold on
for f = 1:3
    for m = 1:85
%         subplot(3,2,m)
        hold on
        % load diff_HR_ave
        load(['3DMAD-' '-' num2str(f) '-' num2str(m) '.mat'], 'diff_HR_ave')
        if f == 1 || f == 2
            plot([1:length(diff_HR_ave)], diff_HR_ave, '*b')
            c1 = c1+1;
        elseif f == 3
            plot([1:length(diff_HR_ave)], diff_HR_ave, '*r')
            c2 = c2+1;
        end
    end
end
title('difference between spatial average HR and ROI HR')
% legend('live', 'attack')
xlabel('each ROI')
ylabel('difference between HR ROI and HR spatial average')
% save % fig
% close

cd '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Code/BPAD2017_Fall'

