function [raw_PPG1] = raw_PPG_get(vid_out1, included_x_All_Final, included_y_All_Final)
% for each small grid region, compute a raw PPG signal by spatially
% averaging pixels in that area. This assumes the face was split into
% specific regions of varying size and shape. 

% input:
% vid_out1 - video input
% tracked_points1 - points around which PPG should be computed
% n1 - controls the size of the square around each grid point from which 
% PPG will be computed, if small there will be ROIs that are omitted and if
% large, there will be overlap between other grid regions PPG computation

% output:
% raw_PPG1 - [T x R], where T is frames and R are regions from which the
% signals were computed

%% debugging
% vid_out1 = vidSin_out;


numFrame = size(included_y_All_Final,2); %size(vid_out1,3); % should be based on for how many frames points were detected and tracked
numGrids = size(included_x_All_Final{1},2);
% TODO: check if the last row of grids is correct

% initialize raw PPG matrix
raw_PPG1 = zeros(floor(numFrame), numGrids);

% for each frame, get an average value inside a ROI
for t = 1:numFrame
% for each grid ROI point
    frame_t = vid_out1(:,:,t);
    x_access = included_x_All_Final{t}; % get coords for each ROI for a given frame
    y_access = included_y_All_Final{t};
    
    for k = 1:numGrids  % if we ignore the last grid point, maybe it won't go over the boundary and no NaN
        grids_xk = round(cell2mat(x_access(k)));
        grids_yk = round(cell2mat(y_access(k))); 
        ROI_grid = frame_t(grids_xk, grids_yk);
        rawPPG_ROI = mean(mean(ROI_grid));
        raw_PPG1(t,k) = rawPPG_ROI;
    
    if sum(sum(isnan(raw_PPG1))) ~= 0
        t
        k
        break
    end
        
    end
    
    if sum(sum(isnan(raw_PPG1))) ~= 0
        break
    end
end
end
