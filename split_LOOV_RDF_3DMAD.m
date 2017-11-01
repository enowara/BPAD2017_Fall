% split features into testing and training by pth person for LOOV approach

% input
% HR_vec_All_Live1 = [];
% SNR_goodness_All_Live1 = [];
% SNR_2_All_Live1 = [];
% diff_HR_med_All_Live1 = [];
% diff_HR_ave_All_Live1 = [];
% 
% HR_vec_All_Live2 = [];
% SNR_goodness_All_Live2 = [];
% SNR_2_All_Live2 = [];
% diff_HR_med_All_Live2 = [];
% diff_HR_ave_All_Live2 = [];
% 
% HR_vec_All_Attack = [];
% SNR_goodness_All_Attack = [];
% SNR_2_All_Attack = [];
% diff_HR_med_All_Attack = [];
% diff_HR_ave_All_Attack = [];

% Mts


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
    
    PdataLtr = [HR_vec_All_live_p_tr, SNR_goodness_All_live_p_tr];%, SNR_2_All_live_p_tr, ...
%        diff_HR_med_All_live_p_tr, diff_HR_ave_All_live_p_tr];
    PdataFtr = [HR_vec_All_attack_p_tr, SNR_goodness_All_attack_p_tr];%, SNR_2_All_attack_p_tr,...
%         diff_HR_med_All_attack_p_tr, diff_HR_ave_All_attack_p_tr];
    PdataLts = [HR_vec_All_live_p_ts, SNR_goodness_All_live_p_ts];%, SNR_2_All_live_p_ts, ...
%         diff_HR_med_All_live_p_ts, diff_HR_ave_All_live_p_ts];
    PdataFts = [HR_vec_All_attack_p_ts, SNR_goodness_All_attack_p_ts];%, SNR_2_All_attack_p_ts,...
%         diff_HR_med_All_attack_p_ts, diff_HR_ave_All_attack_p_ts];
%% append labels
        YtrL = ones(size(PdataLtr,1), 1);
        YtrF = zeros(size(PdataFtr,1), 1);
        YtsL = ones(size(PdataLts,1), 1);
        YtsF = zeros(size(PdataFts,1), 1);
        
        
        Mlist = [MlistL; MlistA];

        Mtr = find(ismember(Mlist(:,2), Str_idx));
        Mts = find(ismember(Mlist(:,2), Sts_idx));

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


        all_miss = find(labelRDF~=Yts); % all misclassified test observations
        missed_vids_idx = Mts(all_miss,:);
        missed_vids = Mlist(missed_vids_idx, :);
%         all_miss = find(labelRDF~=Yts);
%         miss_vids = Mts(:,all_miss);
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
        disp([num2str(predictionAverageRDFLive) '% Average Live RDF accuracy']);
        predictionAverageRDFFake = sum(cell2mat(predictionAllRDFFake))/length(predictionAllRDFFake);
        disp([num2str(predictionAverageRDFFake) '% Average Fake RDF accuracy']);
        
 save([saveFolder '3DMAD_RDF.mat'], 'scores_RDFcell', 'Ytsscell', 'Ytrscell', ...
 'testPeople', 'predictionAllRDF', 'predictionAllRDFLive', 'predictionAllRDFFake', 'missed_vids_All')       
        
        