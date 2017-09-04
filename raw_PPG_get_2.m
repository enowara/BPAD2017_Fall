function [raw_PPG1] = raw_PPG_get_2(vid_out1, tracked_points1, n1)
% for each small grid region, compute a raw PPG signal by spatially
% averaging pixels in that area. This assumes there are equally spaced
% predefined squae grids uniformly distributed over the face. 

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
% tracked_points1 = tracked_points;
% n1 = n;


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
   % for each triangular ROI
    for k = 1:numGrids
        grids_xk = round(cell2mat(x_access(k)));
        grids_yk = round(cell2mat(y_access(k))); 
        
        for n = 1:length(grids_xk)-1
            x_start_temp = floor(grids_xk(n)); % sometimes it goes over the frame -tracking failure?
            y_start_temp = floor(grids_yk(n));

            x_end_temp = floor(grids_xk(n+1));
            y_end_temp = floor(grids_yk(n+1));
            
            % make sure end isn't less than start
            if x_start_temp > x_end_temp
                x_start = x_end_temp;
                x_end = x_start_temp;
            else 
                x_start = x_start_temp;
                x_end = x_end_temp;
            end
            
            if y_start_temp > y_end_temp
                y_start = y_end_temp;
                y_end = y_start_temp;
            else 
                y_start = y_start_temp;
                y_end = y_end_temp;
            end
               
            ROI_grid_n = frame_t(floor(x_start):floor(x_end), floor(y_start):floor(y_end));
            rawPPG_ROI_n(n) = mean(mean(ROI_grid_n));
        end
        raw_PPG1(t,k) = mean(rawPPG_ROI_n);
    
    if sum(sum(isnan(raw_PPG1))) ~= 0
        y_start
        y_end
        x_start
        x_end
        break
    end
        
    end
% append to a rawPPG matrix

% add a condition to make sure the averaged ROI doesn't come outside of the
% defined facial ROI or the frame itself

% stop if any value is NaN - it means the grid ROI start and end are wrong,
% ex if start = end, grid PPG = NaN
    if sum(sum(isnan(raw_PPG1))) ~= 0
        break
    end
end
end
