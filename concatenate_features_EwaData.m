% concatenate feature vectors for training

% plot features / patterns present in live vs attack faces

folderResults = '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/';
datte = '10-10';


%% SNR_goodness
% legend('live', 'attack')
HR_vec_All_Live1 = [];
SNR_goodness_All_Live1 = [];
SNR_2_All_Live1 = [];
diff_HR_med_All_Live1 = [];
diff_HR_ave_All_Live1 = [];

HR_vec_All_Live2 = [];
SNR_goodness_All_Live2 = [];
SNR_2_All_Live2 = [];
diff_HR_med_All_Live2 = [];
diff_HR_ave_All_Live2 = [];

HR_vec_All_Attack = [];
SNR_goodness_All_Attack = [];
SNR_2_All_Attack = [];
diff_HR_med_All_Attack = [];
diff_HR_ave_All_Attack = [];

cd '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/';
cd '10_10/'

MlistL = [];
MlistA =[];

for f = 3:20%1:3
    for m = 1:6%85
        % load
        load(['EwaData-' '-' num2str(f) '-' num2str(m) '.mat'], 'HR_vec', 'SNR_goodness', 'SNR_2', 'diff_HR_med', 'diff_HR_ave')
%             )'EwaData-' '-' num2str(f) '-' num2str(m) '.mat']
%         load([folderResults datte '/' 'EwaData-' '-' num2str(f) '-' num2str(m) '.mat'], ...
%             'HR_vec', 'SNR_goodness', 'SNR_2', 'diff_HR_med', 'diff_HR_ave')
        if f == 7 || f==8 || f== 13 || f ==14 || f == 19 || f== 20 %f == 1
            HR_vec_All_Live1 = [HR_vec_All_Live1; HR_vec'];
            SNR_goodness_All_Live1 = [SNR_goodness_All_Live1; SNR_goodness'];
            SNR_2_All_Live1 = [SNR_2_All_Live1; SNR_2'];
            diff_HR_med_All_Live1 = [diff_HR_med_All_Live1; diff_HR_med'];
            diff_HR_ave_All_Live1 = [diff_HR_ave_All_Live1; diff_HR_ave'];
            
            MlistL = [MlistL; [f m]];
%             HR_vec_All_Live2 = [HR_vec_All_Live2; HR_vec'];
%             SNR_goodness_All_Live2 = [SNR_goodness_All_Live2; SNR_goodness'];
%             SNR_2_All_Live2 = [SNR_2_All_Live2; SNR_2'];
%             diff_HR_med_All_Live2 = [diff_HR_med_All_Live2; diff_HR_med'];
%             diff_HR_ave_All_Live2 = [diff_HR_ave_All_Live2; diff_HR_ave'];
        else %if f == 3
            HR_vec_All_Attack = [HR_vec_All_Attack; HR_vec'];
            SNR_goodness_All_Attack = [SNR_goodness_All_Attack; SNR_goodness'];
            SNR_2_All_Attack = [SNR_2_All_Attack; SNR_2'];
            diff_HR_med_All_Attack = [diff_HR_med_All_Attack; diff_HR_med'];
            diff_HR_ave_All_Attack = [diff_HR_ave_All_Attack; diff_HR_ave'];
            
            MlistA = [MlistA; [f m]];
        end
    end
end



cd '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Code/BPAD2017_Fall'

