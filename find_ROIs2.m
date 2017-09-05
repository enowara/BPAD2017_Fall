function [included_x_All_Save, included_y_All_Save] = find_ROIs2(firstPoints_augmented, tracked_points_mask)
% given 68 landmark points for either the first frame of the video or each
% frame, define ROIs on the face from which PPG will be extracted. Use
% Delanuay triangulation to define triangles as ROIs and remove the eye and
% mouth regions. 

% input:
% firstPoints1 - 68 facial landmarks, either for each frame or only 1
    % frame, [# points, x and y coords]

% output: 
% faceROI - binary face mask excluding eyes and mouth ROIs
% included_x_All_Final - cells containing final x coordinates that are
    % included in each ROI 
% included_y_All_Final - y-coordinate

% first points have 68 landmarks for each frame, x and y coords
% for each frame:

% initialize
included_x_All_Save = [];
included_y_All_Save = [];
for t = 1:size(tracked_points_mask,1)
   
    
    % constraint on the max number of triangles or min size of each triangle
    TRI = delaunay(double(firstPoints_augmented(:,1)),double(firstPoints_augmented(:,2)));
    figure, imshow(firstFrame), hold on, plot(tr_pnts_x, tr_pnts_y, '.b')
    plot(firstPoints_augmented(:,1),firstPoints_augmented(:,2), 'g*')
    triplot(TRI,double(firstPoints_augmented(:,1)),double(firstPoints_augmented(:,2)), 'g')

    % numbers used to define vertices of the triangles correspond to the
    % indices of each facial landmark

    tri_converted_1x = firstPoints_augmented(TRI(:,1),1);
    tri_converted_2x = firstPoints_augmented(TRI(:,2),1);
    tri_converted_3x = firstPoints_augmented(TRI(:,3),1);

    tri_converted_1y = firstPoints_augmented(TRI(:,1),2);
    tri_converted_2y = firstPoints_augmented(TRI(:,2),2);
    tri_converted_3y = firstPoints_augmented(TRI(:,3),2);

    tri_converted_x = [tri_converted_1x tri_converted_2x tri_converted_3x];
    tri_converted_y = [tri_converted_1y tri_converted_2y tri_converted_3y];

    % convert between vectorized indices and x,y coords, get a list of x y
    % coords of the whole img

    % [img_x, img_y] = ind2sub([imgHeight imgWidth], 1:(imgHeight*imgWidth));
    tr_pnts = tracked_points_mask(t,:,:);
    tr_pnts = permute(tr_pnts, [2 3 1]);
%     [img_x, img_y] = ind2sub([imgHeight imgWidth], tr_pnts(:));
    tr_pnts_x = tr_pnts(:,1);
    tr_pnts_y = tr_pnts(:,2);
    % check which points in the image are included inside

    % for each ROI - triangle
    included_x_All1 = [];
    included_y_All1 = [];
    areatrAll1 = [];

    included_x_All = [];
    included_y_All = [];
    areatrAll = [];
    count = 0;
    for tr = 1:size(TRI,1)

        includedtr = inpolygon(tr_pnts_x, tr_pnts_y, round([tri_converted_x(tr,:,:) ...
            tri_converted_x(tr,1,1)]),round([tri_converted_y(tr,:,:) tri_converted_y(tr,1,1)] ));
%         sum(includedtr)

        areatr = polyarea(tri_converted_x(tr,:), tri_converted_y(tr,:));
        includedtr_non0 = find(includedtr);
        included_y = tr_pnts_x(includedtr_non0);
        included_x = tr_pnts_y(includedtr_non0);
    %     [included_x, included_y] = ind2sub([imgHeight imgWidth], includedtr_non0); %use find to save ccors of 
                                                                            % included
                                                                            % points, convert them to x, y
        included_x_All1{tr} = included_x; % save 
        included_y_All1{tr} = included_y;
        areatrAll1 = [areatrAll1; areatr];

        % remove triangles that are empty (mask) or that have less than 10 pixels total
% 
%         if length(included_x) > 100
%             count = count+1;
%             included_x_All{count} = included_x; % save 
%             included_y_All{count} = included_y;
%             areatrAll = [areatrAll; areatr];
%         else 
%             continue
%         end

    end

included_y_All_Save{t} = included_y_All1;
included_x_All_Save{t} = included_x_All1;
%% combine neighboring ROIs
end % end for t

end % end function