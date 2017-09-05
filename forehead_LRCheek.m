function [gridPoints] = forehead_LRCheek(pointsList, firstPoints)
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

    
    %% split F,L,R into smaller ROIs
    % this splits forehead horizontally, not useful, want vertical
%     foreheadGrid1 = foreheadGrid(1:floor(length(foreheadGrid)/3));
%     foreheadGrid2 = foreheadGrid(floor(length(foreheadGrid)/3)+1: ...
%         (floor(length(foreheadGrid)/3)+1+floor(length(foreheadGrid)/3)));
%     foreheadGrid3 = foreheadGrid((floor(length(foreheadGrid)/3)+1+floor(length(foreheadGrid)/3)): end);

    Lcheek1 = Lcheek(1:floor(length(Lcheek)/2));
    Lcheek2 = Lcheek(floor(length(Lcheek)/2)+1:(floor(length(Lcheek)/2)+floor(length(Lcheek)/2)));
    
    Rcheek1 = Rcheek(1:floor(length(Rcheek)/2));
    Rcheek2 = Rcheek(floor(length(Rcheek)/2)+1:(floor(length(Rcheek)/2)+floor(length(Rcheek)/2)));
    
    gridPointsF = pointsList(:,foreheadGrid, :);
    
    % split forehead vertically 
    F1 = max(gridPointsF(1,:,1));
    F2 = min(gridPointsF(1,:,1));
    
    widthF = F1-F2;
    
%     [Fx, Fy] = ind2sub([480 640],gridPointsF(1,:,:));
    
    F_boundx1 = [F2, F2+floor(widthF/3), F2+floor(widthF/3), F2];
    F_boundy1 = [min(gridPointsF(1,:,2)), min(gridPointsF(1,:,2)), max(gridPointsF(1,:,2)), ...
        max(gridPointsF(1,:,2))];

    F_1 = inpolygon(gridPointsF(1,:,1), gridPointsF(1,:,2), F_boundx1, F_boundy1);
    
    gridPointsF1 = gridPointsF(:,F_1,:);
    
    F_boundx2 = [F2+floor(widthF/3), F2+2*floor(widthF/3), F2+2*floor(widthF/3), F2+floor(widthF/3)];
    F_boundy2 = F_boundy1;

    F_2 = inpolygon(gridPointsF(1,:,1), gridPointsF(1,:,2), F_boundx2, F_boundy2);
    
    gridPointsF2 = gridPointsF(:,F_2,:);
    
    F_boundx3 = [F2+2*floor(widthF/3), F2+3*floor(widthF/3), F2+3*floor(widthF/3), F2+2*floor(widthF/3)];
    F_boundy3 = F_boundy1;

    F_3 = inpolygon(gridPointsF(1,:,1), gridPointsF(1,:,2), F_boundx3, F_boundy3);
    
    gridPointsF3 = gridPointsF(:,F_3,:);

    gridPointsL = pointsList(:,Lcheek, :);
    gridPointsL1 = pointsList(:,Lcheek1, :);
    gridPointsL2 = pointsList(:,Lcheek2, :);
    
    gridPointsR = pointsList(:,Rcheek, :);
    gridPointsR1 = pointsList(:,Rcheek1, :);
    gridPointsR2 = pointsList(:,Rcheek2, :);
    
    gridPoints{1} = gridPointsF1;
    gridPoints{2} = gridPointsF3;
    gridPoints{3} = gridPointsF2;
    gridPoints{4} = gridPointsL1;
    gridPoints{5} = gridPointsL2;
    gridPoints{6} = gridPointsR1;
    gridPoints{7} = gridPointsR2;
    
%     figure, imshow(vidSin_out(:,:,1)), hold on, plot(gridPointsF1(1,:,1), gridPointsF1(1,:,2), 'g.')
%     plot(gridPointsF2(1,:,1), gridPointsF2(1,:,2), 'b.')
%     plot(gridPointsF3(1,:,1), gridPointsF3(1,:,2), 'r.')

% end
end