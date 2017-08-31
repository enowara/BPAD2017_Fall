function [raw_PPG1] = raw_PPG_get_rigid_grid(vid_out1, tracked_points1, n1)
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


numFrame = size(tracked_points1,1); %size(vid_out1,3); % should be based on for how many frames points were detected and tracked

% TODO: check if the last row of grids is correct

% initialize raw PPG matrix
raw_PPG1 = zeros(floor(numFrame), size(tracked_points1,2));

% for each frame, get an average value inside a ROI
for t = 1:numFrame
% for each grid ROI point
    frame_t = vid_out1(:,:,t);
    % height and width of ROI changes location as the person moves, so
    % check it again for each frame
    Height = max(tracked_points1(t,:,1)) + n1; %size(vid_out1,2); % Y  % let the ROI be n1 wider and taller, to account for the last row and column
    Width = max(tracked_points1(t,:,2)) + n1; %size(vid_out1,1);  % X
    
    if Height > size(vid_out1,2)
       Height = size(vid_out1,2);
    end
    if Width > size(vid_out1,1)
       Width = size(vid_out1,1);
    end

%     figure,
%     imshow(frame_t, []),    
%     hold on,
%     plot(tracked_points1(t,:,1), tracked_points1(t,:,2), '*r')
    
    % ignore last column and row - end there
    
%     sortX = sort(tracked_points1(t,:,1), 'descend');
%     sortY = sort(tracked_points1(t,:,2), 'descend');
%     
%     [valX, idxX] = max(sortX(:));
%     maxIdxX = find(sortX==valX);
%     max2_idxX = max(maxIdxX) + 1;
%     
%     max2X = sortX(max2_idxX); 
%     Final_max2_idxX = find(tracked_points1(t,:,1) == max2X); % end at these indices
%     
%     [valY, idxY] = max(sortY(:));
%     maxIdxY = find(sortY==valY);
%     max2_idxY = max(maxIdxY) + 1;
%     
%     max2Y = sortY(max2_idxY); 
%     Final_max2_idxY = find(tracked_points1(t,:,2) == max2Y); % end at these indices
    
    for k = 1:size(tracked_points1,2)  % if we ignore the last grid point, maybe it won't go over the boundary and no NaN
        
        x_start_init = floor(tracked_points1(t,k,1)); % sometimes it goes over the frame -tracking failure?
        y_start_init = floor(tracked_points1(t,k,2));
        
        % make sure the grids are within the ROI
        
        if x_start_init < 1
            x_start = min(tracked_points1(1,:,1));
%         elseif x_start_init > Height
%             x_start_init 
        else
            x_start = x_start_init;
        end
        
        if y_start_init < 1
            y_start = min(tracked_points1(1,:,2));
        else
            y_start = y_start_init;
        end
        
        if (x_start_init+(n1-1)) > Height 
            x_start = Height - n1;
            x_end = Height;
        else
            x_end = x_start+n1-1;
        end
        
        if (y_start_init + (n1-1)) > Width
            y_start = Width - n1;
            y_end = Width;
        else
            y_end = y_start+n1-1;
        end

         %floor(tracked_points1(t,k+n1-1,1));  % make sure all regions are included
         %floor(tracked_points1(t,k+n1-1,2));
         
         % make sure the grid points are positive
            if y_start <= 0 
                y_start = 1;
            end
            
            if y_end <= 0 
                y_end = 1;
            end
            
            if x_start <= 0 
                x_start = 1;
            end
            
            if x_end <= 0
                x_end = 1;
            end

% startx, starty
% endx, endy
% plot(x_start, y_start, '*b')
% plot(x_end, y_end, 'g*')
% pause(0.5)
    % add a condition to make sure they dont go out of frame or ROI

    % use grid points locations to select a grid from which to compute raw PPG
% 
    ROI_grid = frame_t(floor(y_start):floor(y_end), floor(x_start):floor(x_end));
    rawPPG_ROI = mean(mean(ROI_grid));
    raw_PPG1(t,k) = rawPPG_ROI;
    
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
