% split features into testing and training by pth person for LOOV approach
warning off
N = size(HR_vec_All_Attack,2); % number of features per face - # ROIs

% here each person has 6 videos

% if splitting by the same video

total_vids = size(HR_vec_All_Attack,1) + size(HR_vec_All_Live1,1);

startTestPerson1 = [1:6:total_vids];
endTestPerson1 = [1:6:total_vids] + 5;

% if splitting by all videos of the same person
% startTestPerson1 = [1:6*6:size(HR_vec_All_Attack,1);];
% endTestPerson1 = [1:6*6:size(HR_vec_All_Attack,1);] + 35;  %?

startTestPerson2 = [];
startTestPerson3 = [];
endTestPerson2 = [];
endTestPerson3 = [];
    
allPeople = startTestPerson1(1):endTestPerson1(end); 

pEnd = 18; 


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
    Str_idx_L = Str_idx;
    Str_idx_A = Str_idx;
    % split all 5 live features
    
    % order of live matrices
%     
%     order_Live = [7,8,13,14,19,20];
%     % order of attack matrices
%     order_Attack = setdiff([3:20],[7,8,13,14,19,20]);
%     
%     Str_idx_L1 = intersect(Str_idx,order_Live);
%     [~,Str_idx_L] = ismember(Str_idx_L1, order_Live);
%     
%     Str_idx_A1 = intersect(Str_idx,order_Attack);
%     [~,Str_idx_A] = ismember(Str_idx_A1, order_Attack);
    
    % feature 1
    HR_vec_All_live_p1 = HR_vec_All_Live1(Str_idx_L,:);% include each tr persons 16 ROIs
%     HR_vec_All_live_p2 = HR_vec_All_Live2(Str_idx,:);
    HR_vec_All_live_p_tr = [HR_vec_All_live_p1];% HR_vec_All_live_p2];
    
    HR_vec_All_attack_p_tr = HR_vec_All_Attack(Str_idx_A,:);
    
    % feature 2
    SNR_goodness_All_live_p1 = SNR_goodness_All_Live1(Str_idx_L,:);% include each tr persons 16 ROIs
%     SNR_goodness_All_live_p2 = SNR_goodness_All_Live2(Str_idx,:);
    SNR_goodness_All_live_p_tr = [SNR_goodness_All_live_p1];% SNR_goodness_All_live_p2];
    
    SNR_goodness_All_attack_p_tr = SNR_goodness_All_Attack(Str_idx_A,:);
    
    % feature 3
    SNR_2_All_live_p1 = SNR_2_All_Live1(Str_idx_L,:);% include each tr persons 16 ROIs
%     SNR_2_All_live_p2 = SNR_2_All_Live2(Str_idx,:);
    SNR_2_All_live_p_tr = [SNR_2_All_live_p1];% SNR_2_All_live_p2];
    
    SNR_2_All_attack_p_tr = SNR_2_All_Attack(Str_idx_A,:);
    
    % feature 4
    diff_HR_med_All_live_p1 = diff_HR_med_All_Live1(Str_idx_L,:);% include each tr persons 16 ROIs
%     diff_HR_med_All_live_p2 = diff_HR_med_All_Live2(Str_idx,:);
    diff_HR_med_All_live_p_tr = [diff_HR_med_All_live_p1];% diff_HR_med_All_live_p2];
    
    diff_HR_med_All_attack_p_tr = diff_HR_med_All_Attack(Str_idx_A,:);
    
    % feature 5HR_vec_All_live_p_tr, SNR_goodness_All_live_p_tr
    diff_HR_ave_All_live_p1 = diff_HR_ave_All_Live1(Str_idx_L,:);% include each tr persons 16 ROIs
%     diff_HR_ave_All_live_p2 = diff_HR_ave_All_Live2(Str_idx,:);
    diff_HR_ave_All_live_p_tr = [diff_HR_ave_All_live_p1];% diff_HR_ave_All_live_p2];
    
    diff_HR_ave_All_attack_p_tr = diff_HR_ave_All_Attack(Str_idx_A,:);
    
    %% TESTING
    
%     find testing people indices     
    Sts_idx = testPerson;
    Sts_idx_L = Sts_idx;
    Sts_idx_A = Sts_idx;
    % keep the order for live and attack
%     Sts_idx_L1 = intersect(Sts_idx,order_Live);
%     [~,Sts_idx_L] = ismember(Sts_idx_L1, order_Live);
%     
%     Sts_idx_A1 = intersect(Sts_idx,order_Attack);
%     [~,Sts_idx_A] = ismember(Sts_idx_A1, order_Attack);
    
    check_L = MlistL(Str_idx)
    
    check_A = MlistA(Str_idx)

%       f_test = testPerson;
    


    % feature 1
    HR_vec_All_live_p1_ts = HR_vec_All_Live1(Sts_idx_L,:);% include each tr persons 16 ROIs
%     HR_vec_All_live_p2_ts = HR_vec_All_Live2(Sts_idx,:);
    HR_vec_All_live_p_ts = [HR_vec_All_live_p1_ts];% HR_vec_All_live_p2_ts];
    
    HR_vec_All_attack_p_ts = HR_vec_All_Attack(Sts_idx_A,:);
    
    % feature 2
    SNR_goodness_All_live_p1_ts = SNR_goodness_All_Live1(Sts_idx_L,:);% include each tr persons 16 ROIs
%     SNR_goodness_All_live_p2_ts = SNR_goodness_All_Live2(Sts_idx,:);
    SNR_goodness_All_live_p_ts = [SNR_goodness_All_live_p1_ts];% SNR_goodness_All_live_p2_ts];
    
    SNR_goodness_All_attack_p_ts = SNR_goodness_All_Attack(Sts_idx_A,:);
    
    % feature 3
    SNR_2_All_live_p1_ts = SNR_2_All_Live1(Sts_idx_L,:);% include each tr persons 16 ROIs
%     SNR_2_All_live_p2_ts = SNR_2_All_Live2(Sts_idx,:);
    SNR_2_All_live_p_ts = [SNR_2_All_live_p1_ts];% SNR_2_All_live_p2_ts];
    
    SNR_2_All_attack_p_ts = SNR_2_All_Attack(Sts_idx_A,:);
    
    % feature 4
    diff_HR_med_All_live_p1_ts = diff_HR_med_All_Live1(Sts_idx_L,:);% include each tr persons 16 ROIs
%     diff_HR_med_All_live_p2_ts = diff_HR_med_All_Live2(Sts_idx,:);
    diff_HR_med_All_live_p_ts = [diff_HR_med_All_live_p1_ts];% diff_HR_med_All_live_p2_ts];
    
    diff_HR_med_All_attack_p_ts = diff_HR_med_All_Attack(Sts_idx_A,:);
    
    % feature 5
    diff_HR_ave_All_live_p1_ts = diff_HR_ave_All_Live1(Sts_idx_L,:);% include each tr persons 16 ROIs
%     diff_HR_ave_All_live_p2_ts = diff_HR_ave_All_Live2(Sts_idx,:);
    diff_HR_ave_All_live_p_ts = [diff_HR_ave_All_live_p1_ts];% diff_HR_ave_All_live_p2_ts];
    
    diff_HR_ave_All_attack_p_ts = diff_HR_ave_All_Attack(Sts_idx_A,:);

    
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

    %% 20:80 instead of LOOV
    PdataL = [HR_vec_All_Live1, SNR_goodness_All_Live1];%, SNR_2_All_Live1, ...
%         diff_HR_med_All_Live1, diff_HR_ave_All_Live1];
    
    PdataF = [HR_vec_All_Attack, SNR_goodness_All_Attack];%, SNR_2_All_Attack, ...
%         diff_HR_med_All_Attack, diff_HR_ave_All_Attack];
    
    %% append labels
        YL = ones(size(PdataL,1), 1);
        YF = zeros(size(PdataF,1), 1);
        
        % if LOOV
%         YtrL = ones(size(PdataLtr,1), 1);
%         YtrF = zeros(size(PdataFtr,1), 1);
%         YtsL = ones(size(PdataLts,1), 1);
%         YtsF = zeros(size(PdataFts,1), 1);
        %% shuffle
        XtrtsTemp = [PdataL; PdataF];
        YtrtsTemp = [YL; YF];
        XYtrtsTemp = [XtrtsTemp YtrtsTemp];
        s = RandStream('mt19937ar','Seed',sum(100*clock));
        orderTrtsi = randperm(s, size(XYtrtsTemp,1));
        XYtrts = XYtrtsTemp(orderTrtsi,:);
% 
        Xtrts = XYtrts(:,1:(end-1));  % is 582, should be 1200?
        Ytrts = XYtrts(:,end);
        
        % split into tr and ts 80:20
        
        Xtr = Xtrts(1:floor(0.8*size(Xtrts)), :);
        Xts = Xtrts(floor(0.8*size(Xtrts))+1:end, :);  
        
        Ytr = Ytrts(1:floor(0.8*size(Xtrts)), :);
        Yts = Ytrts(floor(0.8*size(Xtrts))+1:end, :);  
        % combine live and fake
        
%         % if want balanced classes
%         Ytr = [YtrL(1:80,:); YtrF];
%         Yts = [YtsL(1:5,:); YtsF];
% 
%         Xtr = [PdataLtr(1:80,:); PdataFtr];
%         Xts = [PdataLts(1:5,:); PdataFts];
        
%         % else if using all data, where 2 x more live
%         Ytr = [YtrL; YtrF];
%         Yts = [YtsL; YtsF];
% 
%         Xtr = [PdataLtr; PdataFtr];
%         Xts = [PdataLts; PdataFts];
        
        
        % keep only some of the features
%         idx_feature = [1:22]; % the first 2
        
%         Xtr = Xtr(:,idx_feature);
%         Xts = Xts(:,idx_feature);
%% train a classifier or threshold

% call a classifier function and save result fHR_vec_All_Live1or each p run

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