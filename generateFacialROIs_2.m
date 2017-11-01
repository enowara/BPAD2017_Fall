function [facialRegions] = generateFacialROIs_2(facial_points)
% facial_points = firstPoints_augmented;

% save corners of ROIs in counterclockwise fashion
% 1
% [69 71 20 37 1];
% 2 
% [71 73 28 40 37 20];
% 3
% [73 75 45 43 28]
% 4
% [75 78 17 46 45]

% 5 
% [1 37 40 32 3]

% 6 
% [40 43 53 51]

% 7
% [43 46 17 15 36]

% 8
% [3 32 51 60 6]

% 9
% [36 15 12 56 53]

% 10
% [60 58 9 6]

% 11
% [58 56 12 9]

ROI_list_points = {[69 71 37 1], [71 73 28 40 37 20], [73 75 45 28], ...
    [75 78 17 46 45], [1 40 32 3], [40 43 53 51], ...
    [43 17 15 36], [3 32 51 60 6], [36 15 12 53], ...
    [60 58 9 6], [58 56 12 9]};

N = length(ROI_list_points);
for n = 1:N
    ROI_list_points_i = ROI_list_points{n};
    regioni_temp = pnts2ROI(ROI_list_points_i, facial_points);
    
    % to avoid problems where the ROI is folded into triangles instead of
    % rectangles, remove repeating points except for the first and last one
    regioni_2 = unique(regioni_temp(2:end-1,:), 'rows', 'stable');
    regioni = [regioni_temp(1,:); regioni_2; regioni_temp(end,:)];
%     to_remove = (withoutRepeating, regioni_temp(2:end-1,:));
    
    facialRegions{n} = regioni;
end
%% visualize
% figure, imshow(firstFrame), hold on, 
% for i = 1:N
%     pnts_plot = facialRegions{i};
%     plot(pnts_plot(:,1), pnts_plot(:,2), 'LineWidth', 2)
% %     title(num2str(i))
%     pause()
% end
% hold on
% plot(firstPoints_augmented1(:,1), firstPoints_augmented1(:,2), '*g')