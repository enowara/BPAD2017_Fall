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
    
    % feature 5HR_vec_All_live_p_tr, SNR_goodness_All_live_p_tr
    diff_HR_ave_All_live_p1 = diff_HR_ave_All_Live1(Str_idx,:);% include each tr persons 16 ROIs
    diff_HR_ave_All_live_p2 = diff_HR_ave_All_Live2(Str_idx,:);
    diff_HR_ave_All_live_p_tr = [diff_HR_ave_All_live_p1; diff_HR_ave_All_live_p2];
    
    diff_HR_ave_All_attack_p_tr = diff_HR_ave_All_Attack(Str_idx,:);
    
    %% TESTING
    
    % find testing people indices     
    Sts_idx = testPerson;
   
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
        
%         % if want balanced classes
%         Ytr = [YtrL(1:80,:); YtrF];
%         Yts = [YtsL(1:5,:); YtsF];
% 
%         Xtr = [PdataLtr(1:80,:); PdataFtr];
%         Xts = [PdataLts(1:5,:); PdataFts];
        
%         % else if using all data, where 2 x more live
        Ytr = [YtrL; YtrF];
        Yts = [YtsL; YtsF];

        Xtr = [PdataLtr; PdataFtr];
        Xts = [PdataLts; PdataFts];
        
        
        % keep only some of the features
%         idx_feature = [1:22]; % the first 2
        
%         Xtr = Xtr(:,idx_feature);
%         Xts = Xts(:,idx_feature);
%% train a classifier or threshold

% call a classifier function and save result for each p run

% SVM,put in a fct l8r
        SVMModel = fitcsvm(Xtr,Ytr,'KernelFunction','linear','Standardize',false);
        [labelSVM,score] = predict(SVMModel,Xts);
        predictionSVM = (length(find(labelSVM==Yts))/length(Yts))*100;
        
        % prediction for live and fake separately 
        LiveIdx = find(Yts == 1);
        FakeIdx = find(Yts == 0);
        labelLive = labelSVM(LiveIdx); %label(1:end/2);
        labelFake = labelSVM(FakeIdx); %label((end/2+1):end);
        YtsLive = Yts(LiveIdx); %Yts(1:end/2);
        YtsFake = Yts(FakeIdx); %Yts((end/2+1):end);
        
        SVMModel2 = fitPosterior(SVMModel);
        [~,score_posterior] = resubPredict(SVMModel2);

        predictionSVMLive = (length(find(labelLive==YtsLive))/length(YtsLive))*100;
        predictionSVMFake = (length(find(labelFake==YtsFake))/length(YtsFake))*100;
        
        
scores_SVM_postcell{p} = score_posterior;    
scores_SVMcell{p} = num2cell(score);
Ytsscell{p} = Yts;
Ytrscell{p} = Ytr;
testPeople = [testPeople; testPerson];
labelsSVMcell{p} = labelSVM;
predictionAllSVM = [predictionAllSVM; predictionSVM];
predictionAllSVMLive = [predictionAllSVMLive; predictionSVMLive];
predictionAllSVMFake = [predictionAllSVMFake; predictionSVMFake];


end

predictionAverageSVM = sum(predictionAllSVM)/length(predictionAllSVM);
        disp([num2str(predictionAverageSVM) '% Average SVM accuracy']);

        predictionAverageSVMLive = sum(predictionAllSVMLive)/length(predictionAllSVMLive);
        disp([num2str(predictionAverageSVMLive) '% Average Live SVM accuracy']);
        predictionAverageSVMFake = sum(predictionAllSVMFake)/length(predictionAllSVMFake);
        disp([num2str(predictionAverageSVMFake) '% Average Fake SVM accuracy']);