

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
    

    %% split by handheld or fixed scenario

FixedIdx = [];
    for mm = [3,7,9,13,15,19] -2;
%         mm
        FixedIdx = [FixedIdx (mm-1)*6+1:mm*6];% [[7*(1:6):8*6], [13*6:14*6], [20*6:19*6]]
    end


    %% if splitting both tr and ts into hand vs fixed
% 
% % %     % if all 
    allPeople = startTestPerson1(1):endTestPerson1(end); 
    testPerson = testPersonInit;
    trainPeople = setdiff(allPeople, testPerson); 
% %     
% % %     % if only hand 
% % 
%     allPeople = setdiff(allPeople, FixedIdx);
%     testPerson = setdiff(testPersonInit,FixedIdx);
%     trainPeople = setdiff(allPeople, testPerson); 
%     
% %     % if only fixed
%     allPeople = intersect(allPeople, FixedIdx);
%     testPerson = intersect(testPersonInit, FixedIdx);
%     trainPeople = setdiff(allPeople, testPerson); 
    
    
%     % if splitting only ts
% 
%     % if all 
%     allPeople = startTestPerson1(1):endTestPerson1(end); 
%     testPerson = testPersonInit;
%     trainPeople = setdiff(allPeople, testPerson); 
%     % if only hand 
%     allPeople = setdiff(allPeople, FixedIdx);
%     testPerson = testPersonInit;
%     trainPeople = setdiff(allPeople, testPerson); 
% 
%     % if only fixed
%     allPeople = intersect(allPeople, FixedIdx);
%     testPerson = testPersonInit;
%     trainPeople = setdiff(allPeople, testPerson); 
    %% TESTING
    LiveIdx = [];
    for mm = [7,8,13,14,19,20] -2;
%         mm
        LiveIdx = [LiveIdx (mm-1)*6+1:mm*6];% [[7*(1:6):8*6], [13*6:14*6], [20*6:19*6]]
    end
        FakeIdx = setdiff([1:108], LiveIdx);
%     find testing people indices     
    Sts_idx = testPerson;
    Sts_idx_L = Sts_idx;
    Sts_idx_A = Sts_idx;
    
    Sts_idx_Ltemp = intersect(Sts_idx, LiveIdx);
    Sts_idx_Atemp = intersect(Sts_idx, FakeIdx);
    
    
    orderedLiveIdx_1ts = ismember(Sts_idx_Ltemp, LiveIdx);
    Sts_idx_L = find(orderedLiveIdx_1ts);
    
    ordererAttackIdx_1ts = ismember(Sts_idx_Atemp, FakeIdx);
    Sts_idx_A = find(ordererAttackIdx_1ts);
    % keep the order for live and attack
%     Sts_idx_L1 = intersect(Sts_idx,order_Live);
%     [~,Sts_idx_L] = ismember(Sts_idx_L1, order_Live);
%     
%     Sts_idx_A1 = intersect(Sts_idx,order_Attack);
%     [~,Sts_idx_A] = ismember(Sts_idx_A1, order_Attack);
    
%     check_L = MlistL(Str_idx);
%     
%     check_A = MlistA(Str_idx);

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

    
    %% TRAINING
    
    
    Str_idx = trainPeople;
    Str_idx_Ltemp = intersect(Str_idx, LiveIdx);
    Str_idx_Atemp = intersect(Str_idx, FakeIdx);
    
    
    orderedLiveIdx_1 = ismember(Str_idx_Ltemp, LiveIdx);
    Str_idx_Ltemp = find(orderedLiveIdx_1);
    Str_idx_L = setdiff(Str_idx_Ltemp, Sts_idx_L);
    
    
    ordererAttackIdx_1 = ismember(Str_idx_Atemp, FakeIdx);
    Str_idx_Atemp = find(ordererAttackIdx_1);
    Str_idx_A = setdiff(Str_idx_Atemp, Sts_idx_A);
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
    %%
    liveFolders = 1:2;
    fakeFolders = 3;
    
    % combine all features into training and testing matrices
    PdataLtr = [];
    PdataFtr = [];
    PdataLts = [];
    PdataFts = [];
    
    % all features together
    
    PdataLtr = [HR_vec_All_live_p_tr, SNR_goodness_All_live_p_tr];%;, SNR_2_All_live_p_tr, ...
%         diff_HR_med_All_live_p_tr, diff_HR_ave_All_live_p_tr];
    PdataFtr = [HR_vec_All_attack_p_tr, SNR_goodness_All_attack_p_tr];%, SNR_2_All_attack_p_tr,...
%         diff_HR_med_All_attack_p_tr, diff_HR_ave_All_attack_p_tr];
    PdataLts = [HR_vec_All_live_p_ts, SNR_goodness_All_live_p_ts];%, SNR_2_All_live_p_ts, ...
%         diff_HR_med_All_live_p_ts, diff_HR_ave_All_live_p_ts];
    PdataFts = [HR_vec_All_attack_p_ts, SNR_goodness_All_attack_p_ts];%, SNR_2_All_attack_p_ts,...
%         diff_HR_med_All_attack_p_ts, diff_HR_ave_All_attack_p_ts];

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
%         
%         Xtr = [PdataLtr; PdataFtr];
%         Xts = [PdataLts; PdataFts];
%         Ytr = [YtrL; YtrF];
%         Yts = [YtsL; YtsF];
        %% shuffle
        XtrtsTemp = [PdataL; PdataF];
        YtrtsTemp = [YL; YF];
        Mlist = [MlistL; MlistA];
        XYtrtsTempM = [XtrtsTemp YtrtsTemp Mlist]; % add M matrix of list of idx
        s = RandStream('mt19937ar','Seed',sum(100*clock));
        orderTrtsi = randperm(s, size(XYtrtsTempM,1));
        XYtrtsM = XYtrtsTempM(orderTrtsi,:);

        Xtrts = XYtrtsM(:,1:(end-4));
        Ytrts = XYtrtsM(:,(end-2));  % is 582, should be 1200?
        Mtrts = XYtrtsM(:,end-1:end);
        
%         split into tr and ts 80:20
        
        Xtr = Xtrts(1:floor(0.8*size(Xtrts)), :);
        Xts = Xtrts(floor(0.8*size(Xtrts))+1:end, :);  
%         
        Ytr = Ytrts(1:floor(0.8*size(Xtrts)), :);
        Yts = Ytrts(floor(0.8*size(Xtrts))+1:end, :);  
%         
%         
        Mtr = Mtrts(1:floor(0.8*size(Xtrts)), :);
        Mts = Mtrts(floor(0.8*size(Xtrts))+1:end, :);  
%         combine live and fake
        
%         % if want balanced classes
%         Ytr = [YtrL(1:80,:); YtrF];
%         Yts = [YtsL(1:5,:); YtsF];
% 
%         Xtr = [PdataLtr(1:80,:); PdataFtr];
%         Xts = [PdataLts(1:5,:); PdataFts];
        
%         % else if using all data, where 2 x more live

% 
%         Xtr = [PdataLtr; PdataFtr];
%         Xts = [PdataLts; PdataFts];
        
        
        % keep only some of the features
%         idx_feature = [1:22]; % the first 2
        
%         Xtr = Xtr(:,idx_feature);
%         Xts = Xts(:,idx_feature);


%% train a classifier or threshold

% call a classifier function and save result fHR_vec_All_Live1or each p run

% RDF

        bag = fitensemble(Xtr,Ytr,'Bag',400,'Tree',...
            'type','classification');
        [labelRDF, scores] = bag.predict(Xts);
        predictionRDF = (length(find(labelRDF==Yts))/length(Yts))*100;

        
        
        % prediction for live and fake separately 
        LiveIdx = find(Yts == 1);
        FakeIdx = find(Yts == 0);
        labelLive = labelRDF(LiveIdx); %label(1:end/2);
        labelFake = labelRDF(FakeIdx); %label((end/2+1):end);
        YtsLive = Yts(LiveIdx); %Yts(1:end/2);
        YtsFake = Yts(FakeIdx); %Yts((end/2+1):end);
 
        % find where attack was misclassified as live 
%         missSVMLive = find(labelLive~=YtsLive); % index from ts that was misclassified
        % find where live was misclassified as attack
%         missSVMFake = find(labelFake~=YtsFake);
        
        predtestLive = labelRDF(LiveIdx); %predtest(1:end/2);
        predtestFake = labelRDF(FakeIdx); %predtest((end/2+1):end);

        predictionRDFLive = (length(find(predtestLive==YtsLive))/length(YtsLive))*100;

        predictionRDFFake = (length(find(predtestFake==YtsFake))/length(YtsFake))*100;

%% relate misclassified indices to which video it was
%         Mlist = [MlistL; MlistA];

        all_miss = find(labelRDF~=Yts); % all misclassified test observations
        missed_vids = Mts(all_miss,:);
%         idx_shuffled_Live = find(ismember(Mts(:,1),Sts_idx_A));
%         idx_shuffled_Attack = find(ismember(Mts(:,1),Sts_idx_L));
        
%         fake_miss = [fake_miss; 
% Str_idx_A
% Str_idx_L

%         miss_vids = Mts(all_miss,:);
%         live_miss = [];
%         fake_miss = [];
%         
%         for ii = 1:length(all_miss)
%             if labelRDF(all_miss(ii)) == 1 % fake misclass as live
%                 fake_miss = [fake_miss; Mts(all_miss(ii),:)];% these are more severe
%             elseif labelRDF(all_miss(ii)) == 0 % live misclass as  fake
%                 live_miss = [live_miss; Mts(all_miss(ii),:)];
%             end
%         end

        % plot features of misclassified videos
        
scores_RDFcell{p} = num2cell(scores);
Ytsscell{p} = Yts;
Ytrscell{p} = Ytr;
testPeople = [testPeople; testPerson];
predictionAllRDF{p} = predictionRDF; 
predictionAllRDFLive{p} = predictionRDFLive; 
predictionAllRDFFake{p} = predictionRDFFake;
missed_vids_All{p} = missed_vids;
end

predictionAverageRDF = sum(cell2mat(predictionAllRDF))/length(predictionAllRDF);
        disp([num2str(predictionAverageRDF) '% Average RDF accuracy']);

        predictionAverageRDFLive = sum(cell2mat(predictionAllRDFLive))/length(predictionAllRDFLive);
        disp([num2str(predictionAverageRDFLive) '% Average RDF SVM accuracy']);
        predictionAverageRDFFake = sum(cell2mat(predictionAllRDFFake))/length(predictionAllRDFFake);
        disp([num2str(predictionAverageRDFFake) '% Average Fake RDF accuracy']);

        
        save('RDF_EwaData_10_29.mat')