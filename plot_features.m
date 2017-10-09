% plot features / patterns present in live vs attack faces

folderResults
fileNameList
%% SNR_goodness
figure,
hold on
title('SNR goodness of each ROIs HR') 
% legend('live', 'attack')
xlabel('HR of each ROI')
ylabel('SNR goodness')
for f = 1:3
    for m = 1:length(img_names)
        % load diff_HR_med
        if f == 1 || f == 2
            plot(HR_vec, SNR_goodness, '*b')
        elseif f == 3
            plot(HR_vec, SNR_goodness, '*r')
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
for f = 3
    for m = 1%:length(img_names)
        % load diff_HR_med
        if f == 1 || f == 2
            plot(HR_vec, SNR_2, '*b')
        elseif f == 3
            plot(HR_vec, SNR_2, '*r')
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
    for m = 1%:length(img_names)
        % load diff_HR_med
        if f == 1 || f == 2
            plot([1:length(diff_HR_med)], diff_HR_med, '*b')
        elseif f == 3
            plot([1:length(diff_HR_med)], diff_HR_ave, '*r')
        end
    end
end
% save % fig
% close
%% diff_HR_ave over facial ROIs

figure,
hold on
for f = 3
    for m = 1%:length(img_names)
        % load diff_HR_med
        if f == 1 || f == 2
            plot([1:length(diff_HR_ave)], diff_HR_ave, '*b')
        elseif f == 3
            plot([1:length(diff_HR_ave)], diff_HR_ave, '*r')
        end
    end
end
title('difference between spatial average HR and ROI HR')
% legend('live', 'attack')
xlabel('each ROI')
ylabel('difference between HR ROI and HR spatial average')
% save % fig
% close

