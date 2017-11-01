% face spatial map: compute strength of PPG signal and how similar the HR
% estimates are from each ROI on the face

% repeat this for all videos and compare live vs attack
 
% for f = 1:3
%     figure,
%     hold on
%     for m = 1:85
% %         load SNR around the max peak
%         if f == 1 
%          SNR_goodness = SNR_goodness_All_Live1(m,:);
%          elseif f == 2
%              SNR_goodness = SNR_goodness_All_Live2(m,:);
%          elseif f == 3
%              SNR_goodness = SNR_goodness_All_Attack(m,:);
%         end
        
%         subplot(ceil(sqrt(length(missed_vid_p(:,1)))),ceil(sqrt(length(missed_vid_p(:,1)))),pp)
%         title('live vs attack handheld')
%         hold on
        % load HR_vec, SNR_goodness
%         load(['3DMAD-' '-' num2str(f) '-' num2str(m) '.mat'], 'HR_vec', 'SNR_goodness')
            
SNR_goodness_All_Live1_final = [SNR_goodness_All_Live1 zeros(size(SNR_goodness_All_Live1,1),1)];
figure,  imagesc(reshape(median(SNR_goodness_All_Live1_final,1), [4,3]))
caxis([min((median(SNR_goodness_All_Live1_final,1))) max((median(SNR_goodness_All_Live1_final,1)))])
colorbar

SNR_goodness_All_Live2_final = [SNR_goodness_All_Live2 zeros(size(SNR_goodness_All_Live2,1),1)];
figure,  imagesc(reshape(median(SNR_goodness_All_Live2_final,1), [4,3]))
caxis([min((median(SNR_goodness_All_Live2_final,1))) max((median(SNR_goodness_All_Live2_final,1)))])
colorbar

           
SNR_goodness_All_Attack_final = [SNR_goodness_All_Attack zeros(size(SNR_goodness_All_Attack,1),1)];
figure, imagesc(reshape(median(SNR_goodness_All_Attack_final,1), [4,3]))
caxis([min((median(SNR_goodness_All_Attack_final,1))) max((median(SNR_goodness_All_Attack_final,1)))])
colorbar
           
           %%
           % suming HR over all people doesn't make much sense because
           % it'll vary too much
% HR_vec_All_Live1_final = [HR_vec_All_Live1 zeros(size(HR_vec_All_Live1,1),1)];
%            figure,  imagesc(reshape(mean(HR_vec_All_Live1_final,1), [4,3]))
%            caxis([30 150])
%            colorbar
% 
% HR_vec_All_Live2_final = [HR_vec_All_Live2 zeros(size(HR_vec_All_Live2,1),1)];
%            figure,  imagesc(reshape(mean(HR_vec_All_Live2_final,1), [4,3]))
%            caxis([30 150])
%            colorbar
% 
%            
% HR_vec_All_Attack_final = [HR_vec_All_Attack zeros(size(HR_vec_All_Attack,1),1)];
%            figure, imagesc(reshape(mean(HR_vec_All_Attack_final,1), [4,3]))
%            caxis([30 150])
%            colorbar  

%% 
diff_HR_med_All_Live1_final = [diff_HR_med_All_Live1 zeros(size(HR_vec_All_Live1,1),1)];
           figure,  imagesc(reshape(abs(mean(diff_HR_med_All_Live1_final,1)), [4,3]))
caxis([min((abs(mean(diff_HR_med_All_Live1_final,1)))) max((abs(mean(diff_HR_med_All_Live1_final,1))))])
           colorbar

diff_HR_med_All_Live2_final = [diff_HR_med_All_Live2 zeros(size(HR_vec_All_Live2,1),1)];
           figure,  imagesc(reshape(abs(mean(diff_HR_med_All_Live2_final,1)), [4,3]))
caxis([min((abs(mean(diff_HR_med_All_Live2_final,1)))) max((abs(mean(diff_HR_med_All_Live2_final,1))))])
           colorbar

           
diff_HR_med_All_Attack_final = [diff_HR_med_All_Attack zeros(size(HR_vec_All_Attack,1),1)];
           figure, imagesc(reshape(abs(mean(diff_HR_med_All_Attack_final,1)), [4,3]))
caxis([min((abs(mean(diff_HR_med_All_Attack_final,1)))) max((abs(mean(diff_HR_med_All_Attack_final,1))))])
           colorbar

%%
           
% 
%         end
%         
%     end
% end
        
        
% for f 
%     for m
% %         load HR
%     if f == 1 
%          HR_vec = HR_vec_All_Live1(m,:);
%          elseif f == 2
%              HR_vec = HR_vec_All_Live2(m,:);
%          elseif f == 3
%              HR_vec = HR_vec_All_Attack(m,:);    
%     end
%     end
% end
%          

