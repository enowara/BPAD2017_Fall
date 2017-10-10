% split features into testing and training by pth person for LOOV approach

N = size(HR_vec_All_Attack,2); % number of features per face - # ROIs

startTestPerson1 = [1:5:85];
endTestPerson1 = [1:5:85] + 4;

startTestPerson2 = [];
startTestPerson3 = [];
endTestPerson2 = [];
endTestPerson3 = [];
    
allPeople = startTestPerson1(1):endTestPerson1(end); 
%     allPeople = startTestPerson1(1):endTestPerson3(end);
%     pEnd = 15;
pEnd = 17; 


predictionAllSVM = [];
predictionAllSVMLive = [];
predictionAllSVMFake = [];
testPeople = [];
labelsSVM = [];
predtests = [];
Ytss = [];

for p = 1:pEnd
       
    testPerson1 = startTestPerson1(p):endTestPerson1(p);
    if isempty(startTestPerson2) ~= 1
        testPerson2 = startTestPerson2(p):endTestPerson2(p);
    else
        testPerson2 = [];
    end
     if isempty(startTestPerson2) ~= 1
        testPerson3 = startTestPerson3(p):endTestPerson3(p);
     else
         testPerson3 = [];
     end
    testPersonInit = [testPerson1 testPerson2 testPerson3];
    
    testPerson = testPersonInit;
    trainPeople = setdiff(allPeople, testPerson); 
    
    %% TRAINING
    
    Str_idx = trainPeople;
    

    % split all 5 live features

    % feature 1
    HR_vec_All_live_p1 = HR_vec_All_Live1(Str_idx,:);% include each tr persons 16 ROIs
    HR_vec_All_live_p2 = HR_vec_All_Live2(Str_idx,:);
    HR_vec_All_live_p_tr = [HR_vec_All_live_p1; HR_vec_All_live_p2];
    
    HR_vec_All_attack_p_tr = HR_vec_All_Attack(Str_idx,:);
    
    % feature 2
    SNR_goodness_All_live_p1 = SNR_goodness_All_Live1(Str_idx,:);% include each tr persons 16 ROIs
    SNR_goodness_All_live_p2 = SNR_goodness_All_Live2(Str_idx,:);
    SNR_goodness_All_live_p_tr = [SNR_goodness_All_live_p1; SNR_goodness_All_live_p2];
    
    SNR_goodness_All_attack_p_tr = SNR_goodness_All_Attack(Str_idx,:);
    
    % feature 3
    SNR_2_All_live_p1 = SNR_2_All_Live1(Str_idx,:);% include each tr persons 16 ROIs
    SNR_2_All_live_p2 = SNR_2_All_Live2(Str_idx,:);
    SNR_2_All_live_p_tr = [SNR_2_All_live_p1; SNR_2_All_live_p2];
    
    SNR_2_All_attack_p_tr = SNR_2_All_Attack(Str_idx,:);
    
    % feature 4
    diff_HR_med_All_live_p1 = diff_HR_med_All_Live1(Str_idx,:);% include each tr persons 16 ROIs
    diff_HR_med_All_live_p2 = diff_HR_med_All_Live2(Str_idx,:);
    diff_HR_med_All_live_p_tr = [diff_HR_med_All_live_p1; diff_HR_med_All_live_p2];
    
    diff_HR_med_All_attack_p_tr = diff_HR_med_All_Attack(Str_idx,:);
    
    % feature 5
    diff_HR_ave_All_live_p1 = diff_HR_ave_All_Live1(Str_idx,:);% include each tr persons 16 ROIs
    diff_HR_ave_All_live_p2 = diff_HR_ave_All_Live2(Str_idx,:);
    diff_HR_ave_All_live_p_tr = [diff_HR_ave_All_live_p1; diff_HR_ave_All_live_p2];
    
    diff_HR_ave_All_attack_p_tr = diff_HR_ave_All_Attack(Str_idx,:);
    
    %% TESTING
    
    % find testing people indices     
    Sts_pStart = (testPerson-1)*N+1;
    Sts_pEnd = (testPerson)*N;
    Sts_idx = [];
    for ll = 1:length(Sts_pStart)
        Sts_i = Sts_pStart(ll):Sts_pEnd(ll);
        Sts_idx = [Sts_idx Sts_i];
    end    

    % feature 1
    HR_vec_All_live_p1_ts = HR_vec_All_Live1(Sts_idx,:);% include each tr persons 16 ROIs
    HR_vec_All_live_p2_ts = HR_vec_All_Live2(Sts_idx,:);
    HR_vec_All_live_p_ts = [HR_vec_All_live_p1_ts; HR_vec_All_live_p2_ts];
    
    HR_vec_All_attack_p_ts = HR_vec_All_Attack(Sts_idx,:);
    
    % feature 2
    SNR_goodness_All_live_p1_ts = SNR_goodness_All_Live1(Sts_idx,:);% include each tr persons 16 ROIs
    SNR_goodness_All_live_p2_ts = SNR_goodness_All_Live2(Sts_idx,:);
    SNR_goodness_All_live_p_ts = [SNR_goodness_All_live_p1_ts; SNR_goodness_All_live_p2_ts];
    
    SNR_goodness_All_attack_p_ts = SNR_goodness_All_Attack(Sts_idx,:);
    
    % feature 3
    SNR_2_All_live_p1_ts = SNR_2_All_Live1(Sts_idx,:);% include each tr persons 16 ROIs
    SNR_2_All_live_p2_ts = SNR_2_All_Live2(Sts_idx,:);
    SNR_2_All_live_p_ts = [SNR_2_All_live_p1_ts; SNR_2_All_live_p2_ts];
    
    SNR_2_All_attack_p_ts = SNR_2_All_Attack(Sts_idx,:);
    
    % feature 4
    diff_HR_med_All_live_p1_ts = diff_HR_med_All_Live1(Sts_idx,:);% include each tr persons 16 ROIs
    diff_HR_med_All_live_p2_ts = diff_HR_med_All_Live2(Sts_idx,:);
    diff_HR_med_All_live_p_ts = [diff_HR_med_All_live_p1_ts; diff_HR_med_All_live_p2_ts];
    
    diff_HR_med_All_attack_p_ts = diff_HR_med_All_Attack(Sts_idx,:);
    
    % feature 5
    diff_HR_ave_All_live_p1_ts = diff_HR_ave_All_Live1(Sts_idx,:);% include each tr persons 16 ROIs
    diff_HR_ave_All_live_p2_ts = diff_HR_ave_All_Live2(Sts_idx,:);
    diff_HR_ave_All_live_p_ts = [diff_HR_ave_All_live_p1_ts; diff_HR_ave_All_live_p2_ts];
    
    diff_HR_ave_All_attack_p_ts = diff_HR_ave_All_Attack(Sts_idx,:);

    
    liveFolders = 1:2;
    fakeFolders = 3;
    
    % combine all features into training and testing matrices
    PdataLtr = [];
    PdataFtr = [];
    PdataLts = [];
    PdataFts = [];
    
    % all features together
    
    PdataLtr = [HR_vec_All_live_p_tr, SNR_goodness_All_live_p_tr, SNR_2_All_live_p_tr, ...
        diff_HR_med_All_live_p_tr, diff_HR_ave_All_live_p_tr];
    PdataFtr = [HR_vec_All_attack_p_tr, SNR_goodness_All_attack_p_tr, SNR_2_All_attack_p_tr,...
        diff_HR_med_All_attack_p_tr, diff_HR_ave_All_attack_p_tr];
    PdataLts = [HR_vec_All_live_p_ts, SNR_goodness_All_live_p_ts, SNR_2_All_live_p_ts, ...
        diff_HR_med_All_live_p_ts, diff_HR_ave_All_live_p_ts];
    PdataFts = [HR_vec_All_attack_p_ts, SNR_goodness_All_attack_p_ts, SNR_2_All_attack_p_ts,...
        diff_HR_med_All_attack_p_ts, diff_HR_ave_All_attack_p_ts];
%% append labels
        YtrL = ones(size(PdataLtr,1), 1);
        YtrF = zeros(size(PdataFtr,1), 1);
        YtsL = ones(size(PdataLts,1), 1);
        YtsF = zeros(size(PdataFts,1), 1);

        % combine live and fake
        
        Ytr = [YtrL; YtrF];
        Yts = [YtsL; YtsF];

        Xtr = [PdataLtr; PdataFtr];
        Xts = [PdataLts; PdataFts];
%% train a classifier or threshold

% call a classifier function and save result for each p run
end