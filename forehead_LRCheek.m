function [gridPointsF, gridPointsL, gridPointsR] = forehead_LRCheek(pointsList, firstPoints)
% input:
% pointsList - tracked points time x points x xy 
% firstPoints - landmark points of interest

%  output:
% gridPointsF - points within tracked points that are inside the boundary
    % of defined forehead
% gridPointsL - left cheek
% gridPointsR - right cheek
% for t = 1%:size(pointsList,1)    
t=1; % TO DO: Problem when # points per frame varies
    % whole face - lots of missing parts
    % between eyebrows and chin
    eyebrows1 = [firstPoints(18:22,1), firstPoints(18:22,2)];
    eyebrows2 = [firstPoints(23:27,1), firstPoints(23:27,2)];
    eyebrows = [eyebrows1; eyebrows2];
        
    eyebrowsWidth = max(eyebrows(:,1)) - min(eyebrows(:,1));
    forehead1 = [eyebrows(:,1), (eyebrows(:,2)-round(eyebrowsWidth/2))];
    forehead2 = [eyebrows(:,1), (eyebrows(:,2))];
    
    foreheadx = [forehead1(:,1); forehead2(end:-1:1,1)];
    foreheady = [forehead1(:,2); forehead2(end:-1:1,2)];
       
    foreheadGrid = find(pointsList(t,:,2) < (max(forehead2(:,2)))); 
    
    Lcheeki = [firstPoints(1:9,1), firstPoints(1:9,2)];
    LcheekY2 = find(pointsList(t,:,2) > round(min(Lcheeki(:,2))));  % FIXME!!

    LcheekX2 = find(pointsList(t,:,1) < round(max(Lcheeki(:,1))));
    
    RcheekX2 = find(pointsList(t,:,1) > round(max(Lcheeki(:,1))));

    Lcheek= intersect(LcheekX2,LcheekY2);
    Rcheek = intersect(RcheekX2,LcheekY2);

    gridPointsF = pointsList(:,foreheadGrid, :);
    gridPointsL = pointsList(:,Lcheek, :);
    gridPointsR = pointsList(:,Rcheek, :);
% end
end