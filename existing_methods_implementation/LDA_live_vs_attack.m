% LDA: Reduce the distance among alive videos while enlarge the distance between ..
% alive videos (or the center) and fake videos

addpath('LDA or FDA code with tutorial/LDA or FDA code with tutorial/')
% compute feature matrices using different features, like entropy, cross
% corr. or load SNR, HR values for each videos ROIs

% dataset = '3DMAD';
dataset = 'EwaData';

rho_mf_live1 = [];
rho_mf_ROIs_attack = [];

Entr_mf_live1 = [];
Entr_mf_attack = [];

Entropy_ROIs_live1 = [];
Entropy_ROIs_attack = [];

ip_mf_live1 = [];
ip_mf_attack = [];

Ph_mf_live1 = [];
Ph_mf_attack = [];

if strcmp(dataset, '3DMAD')
    fList = 1:3;
    mList = 1:85;
    fLive = [1,2];
    mainFolder = '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/Live_vs_Fake_ROI/10-08/';
elseif strcmp(dataset, 'EwaData')
    fList = 3:20;
    mList = 1:6;
    fLive = [7, 8, 13, 14, 19, 20];
    mainFolder = '/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/Liveness_Detection_Security/Results/BPAD2017_Fall/EwaData/10_10/';
end

for f = fList
    for m = mList
        % load PPG 
        if strcmp(dataset, '3DMAD')
            load([mainFolder '3DMAD-' '-' num2str(f) '-' num2str(m) '.mat'], 'PPG_filt')
        elseif strcmp(dataset, 'EwaData')
            load([mainFolder 'EwaData-' '-' num2str(f) '-' num2str(m) '.mat'], 'PPG_filt')
        end
        % compute feature
        N = size(PPG_filt,2);
        
        rho_mf = cross_corr_ROIs(PPG_filt, N);
        Entr_mf = entropy_cross_ROIs(PPG_filt, N);   
        Entropy_mf = entropy_ROIs(PPG_filt, N);
        ip_mf = inner_product_ROIs(PPG_filt, N);   
        Ph_mf = phase_ROIs(PPG_filt, N);   


%         if f == 1 
%         if f == 7 || f==8 || f== 13 || f ==14 || f == 19 || f== 20 %f == 1
          if ismember(f, fLive)
            rho_mf_live1 = [rho_mf_live1; rho_mf];
            Entr_mf_live1 = [Entr_mf_live1; Entr_mf];
            Entropy_ROIs_live1 = [Entropy_ROIs_live1; Entropy_mf];
            ip_mf_live1 = [ip_mf_live1; ip_mf];
            Ph_mf_live1 = [Ph_mf_live1; Ph_mf];
            
            
%         elseif f == 2
%             rho_mf_live2 = [rho_mf_live2; rho_mf];
%             Entr_mf_live2 = [Entr_mf_live2; Entr_mf];
%             Entropy_ROIs_live2 = [Entropy_ROIs_live2; Entropy_mf];
%             ip_mf_live2 = [ip_mf_live2; ip_mf];
%         elseif f == 3   
          else
            rho_mf_ROIs_attack = [rho_mf_ROIs_attack; rho_mf];
            Entr_mf_attack = [Entr_mf_attack; Entr_mf];
            Entropy_ROIs_attack = [Entropy_ROIs_attack; Entropy_mf];
            ip_mf_attack = [ip_mf_attack; ip_mf];
            Ph_mf_attack = [Ph_mf_attack; Ph_mf];
          end
    end 
end

% append for all videos 

% c1
% c2

% take 2 classes and project them into a new space such that the difference
% between the 2 classes is max
[y1_1, y2_1] = First_LDA_example(rho_mf_live1, rho_mf_ROIs_attack);
% [y1_2, y2_2] = First_LDA_example([real(Entr_mf_live1); real(Entr_mf_live2)], real(Entr_mf_attack));
[y1_3, y2_3] = First_LDA_example(Entropy_ROIs_live1, Entropy_ROIs_attack);
[y1_4, y2_4] = First_LDA_example(ip_mf_live1, ip_mf_attack);
[y1_5, y2_5] = First_LDA_example(Ph_mf_live1, Ph_mf_attack);

figure, plot(y1_1, 'b*'), hold on, plot(y2_1, 'r*')
% figure, plot(y1_2, 'b*'), hold on, plot(y2_2, 'r*')
figure, plot(y1_3, 'b*'), hold on, plot(y2_3, 'r*')
figure, plot(y1_4, 'b*'), hold on, plot(y2_4, 'r*')
figure, plot(y1_5, 'b*'), hold on, plot(y2_5, 'r*')


%% then do classification on the projected data
        XtrtsTemp = [real(y1_1); real(y2_1)];
        YL = zeros(size(y1_1,1),1);
        YF = ones(size(y2_1,1),1);       
        
        YtrtsTemp = [YL; YF];
        XYtrtsTemp = [XtrtsTemp YtrtsTemp]; % add M matrix of list of idx
        s = RandStream('mt19937ar','Seed',sum(100*clock));
        orderTrtsi = randperm(s, size(XYtrtsTemp,1));
        XYtrts = XYtrtsTemp(orderTrtsi,:);

        Xtrts = XYtrts(:,1:(end-1));
        Ytrts = XYtrts(:,(end));  
        
        
        Xtr = Xtrts(1:floor(0.8*size(Xtrts)), :);
        Xts = Xtrts(floor(0.8*size(Xtrts))+1:end, :);  

        Ytr = Ytrts(1:floor(0.8*size(Xtrts)), :);
        Yts = Ytrts(floor(0.8*size(Xtrts))+1:end, :);  
  
%%
    bag = fitensemble(Xtr,Ytr,'Bag',400,'Tree',...
            'type','classification');
        [labelRDF, scores] = bag.predict(Xts);
        predictionRDF = (length(find(labelRDF==Yts))/length(Yts))*100;
%%
        SVMModel = fitcsvm(Xtr,Ytr,'KernelFunction','RBF','Standardize',false);
        [labelSVM,score] = predict(SVMModel,Xts);
        predictionSVM = (length(find(labelSVM==Yts))/length(Yts))*100;
        