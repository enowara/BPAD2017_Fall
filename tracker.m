%CONFIDENTIAL (C) Mitsubishi Electric Research Labs (MERL) 2017
%Ewa Nowara
%May 18 2017

% this code runs once on the whole video and does not reinitialize every
% time epoch or once one of the constraints on quality of tracked points is
% broken 
function [tracked_points1] = tracker(vid1, init_grids1, vis)
% track each small initialized grid region within a larger ROI by selecting good
% features to track and tracking them over time. 
% reinitialize tracker every t seconds, set n=t = 5


% input:
% vid - video in green channel or IR, [w x h x t], where t
% is time in frames
% init_grids - initialized grid regions locations - for the first frame, [X x Y]
% eps - maximum distance in pixels that tracker can be off, the tracker
% error should not be more than eps = 2 pixels 
% n - minimum number of features necessary to remain tracked before
% reinitialization

% output:
% updated x,y locations of grid regions for each frame. [X x Y x T], where t
% is time in frames

% TODO: RANSAC, SURF or miniEigenfeatures will all detect points
% differently
% reinitialize each time these conditions defined by params are broken

%% debugging
% vid1 = vid_out;
% init_grids1 = init_grids4;
% n1 = n;

% adapted example from https://www.mathworks.com/help/vision/examples/face-detection-and-tracking-using-the-klt-algorithm.html

%% update - initialization of minimum parameters
% to improve tracking the following can be set

minPointQual = 0.001; % min. quality of detected points - must use a 1% minimum accepted quality of corners within ROI,  scalar value in the range [0,1]. 
% The minimum accepted quality of corners represents a fraction of the maximum corner metric value in the image. Larger values can be used to remove erroneous corners.

% NumStrongPoints = 2000; % chose this many top strongest points 
strengthPercent = 1;%0.30;
MaxError = 2; % 1 or 2 are good, % distance in pixels from the original location of the points to the final location after the backward tracking.
% Forward-backward error threshold, recommended 0-3

% minVisiblePointsLeft = 2000; % if less than this many points are left to track, break and reinitialize
leftPercent = 0.25;
maxDistSimilarity = 4;
%%
if ndims(vid1) == 3
    firstFrame = vid1(:,:,1); % if 1 channel
    numFrame = size(vid1,3);
elseif ndims(vid1) == 4
    firstFrame = vid1(:,:,:,1); % if RGB
    numFrame = size(vid1,4);
end

% define a rectangular ROI within which to track (min, max of grid points)

bbox = [min(init_grids1(:,1)), min(init_grids1(:,2)), ...   % format: [xmin ymin width height]
    (max(init_grids1(:,1)) - min(init_grids1(:,1))), ... 
    (max(init_grids1(:,2)) - min(init_grids1(:,2))) ];

% % visualize:
% firstFrame = insertShape(firstFrame, 'Rectangle', bbox);
% figure; imshow(firstFrame); title('Detected face');

init_grids_toTrack = init_grids1;
% Detect feature points in the region. Different methods of detecting
% feature points
points = detectMinEigenFeatures(firstFrame, 'MinQuality', minPointQual, 'ROI', bbox);
% points = detectSURFFeatures(firstFrame, 'MetricThreshold', 100-100*minPointQual, 'ROI', bbox);
if length(points) == 0
    points = detectMinEigenFeatures(firstFrame, 'ROI', bbox); % if there are no points detected that meet the quality criteria, 
end

NumStrongPoints = floor(length(points)*strengthPercent); % take top % strongest points
points = points.selectStrongest(NumStrongPoints); 

minVisiblePointsLeft = 2;%floor(length(points)*leftPercent); % must have % of new strongest points left in order to continue tracking
% visualize: Display the detected points.
% figure, imshow(firstFrame), hold on, title('Detected features');
% plot(points);

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', MaxError);  % Forward-backward error threshold, 

% Initialize the tracker with the initial point locations and the initial
% video frame.
points = points.Location;
initialize(pointTracker, points, firstFrame);

% Make a copy of the points to be used for computing the geometric
% transformation between the points in the previous and the current frames
oldPoints = points;

%% update - initialization of minimum parameters
% to improve tracking the following can be set
% minPointQual = 0.001; % min. quality of detected points 
% NumStrongPoints = 2000; % chose this many top strongest points 
% MaxError = 2;

for t = 1:numFrame
    % get the next frame
    nextFrame = vid1(:,:,t); % if one channel, TODO: make it work on RGB

    % Track the points. Note that some points may be lost.
    [points, isFound] = step(pointTracker, nextFrame);
    visiblePoints = points(isFound, :);
    oldInliers = oldPoints(isFound, :);

    if size(visiblePoints, 1) >= minVisiblePointsLeft % need at least 2 points

        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            oldInliers, visiblePoints, 'similarity', 'MaxDistance', maxDistSimilarity);

%         Transform Type              Minimum Number of Matched Pairs of Points
%                 'similarity'                        2
%                 'affine'                            3
%                 'projective'                        4
        
        % Apply the transformation to the grid points 
        init_grids_toTrack = transformPointsForward(xform, init_grids_toTrack);
        % update grid points
        tracked_points1(t,:,:) = init_grids_toTrack;

        % Insert a bounding box around the object being tracked
%         bboxPolygon = reshape(init_grids_toTrack', 1, []);
%         nextFrame = insertShape(nextFrame, 'Polygon', bboxPolygon, ...
%             'LineWidth', 2);
    if vis ==1
        % Display tracked points
        nextFrame = insertMarker(nextFrame, visiblePoints, '+', ...
            'Color', 'blue');
        
        % %visualize: 
        imshow(nextFrame,[])
        hold on
        plot(tracked_points1(t,:,1), tracked_points1(t,:,2), '*g')
        plot(init_grids1(:,1), init_grids1(:,2), '*r')
        drawnow
    end
        % Reset the points
        oldPoints = visiblePoints;
        setPoints(pointTracker, oldPoints);
    else 
        disp('tracker lost')
        
    end
    

end

% Clean up
release(pointTracker);

end