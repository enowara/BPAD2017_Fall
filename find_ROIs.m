function [faceROI_save, included_x_All_Save, included_y_All_Save, firstPoints_augmented] = find_triangle_ROIs(firstPoints1, vidSin_out, round2, faceROI)
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
faceROI_save = [];
included_x_All_Save = [];
included_y_All_Save = [];
for t = 1:size(vidSin_out,3)
    
    firstFrame = vidSin_out(:,:,t);
    if round2 == 2
        if ndims(firstPoints1) ==3
            firstPoints_augmented =firstPoints1(t,:,:);
            firstPoints_augmented = permute(firstPoints_augmented, [2 3 1]);
        else
            firstPoints_augmented =firstPoints1;
        end
        
    else
        
       
    if ndims(firstPoints1) ==3
        firstPoints2 = firstPoints1(t, :,:); % if more than one frame.
        firstPoints2 = permute(firstPoints2, [2 3 1]);
    else
        % otherwise if only one frame
        firstPoints2 = firstPoints1;
    end

    % the whole face is here
    whole = [firstPoints2(1:68,1), firstPoints2(1:68,2)];

    % between eyebrows and chin
    eyebrows1 = [firstPoints2(18:22,1), firstPoints2(18:22,2)];
    eyebrows2 = [firstPoints2(23:27,1), firstPoints2(23:27,2)];
    eyebrows = [eyebrows1; eyebrows2];

    chin = [firstPoints2(1:17,1), firstPoints2(1:17,2)];

    eyebrowsWidth = max(eyebrows(:,1)) - min(eyebrows(:,1));
    % add some vertical height to include forehead
    forehead1 = [eyebrows(:,1), (eyebrows(:,2)-round(eyebrowsWidth/2))];
    forehead2 = [eyebrows(:,1), (eyebrows(:,2))];

    % plot([whole_face(:,1)], [whole_face(:,2)], 'r.');

    whole_face1 = [forehead1(:,1); chin(end:-1:1,1)];
    whole_face2 = [forehead1(:,2); chin(end:-1:1,2)];
    whole_face = [(whole_face1(:)) whole_face2];

    regionMask_whole_face = roipoly(firstFrame, whole_face(:,1), whole_face(:,2));
    % 
    % tstImg1 = im2double(firstFrame).*regionMask_whole_face;
    % figure, imshow(tstImg1)

    eyes = [firstPoints2(48:-1:37,1), firstPoints2(48:-1:37,2)];
    eyes1 = [firstPoints2(37:42,1), firstPoints2(37:42,2)];
    eyes2 = [firstPoints2(43:48,1), firstPoints2(43:48,2)];

    [valeye1, indeye1]= max(eyes1(:,2));
    [valeye3, indeye3]= min(eyes1(:,1));

    [valeye2, indeye2]= max(eyes2(:,2));
    [valeye4, indeye4]= max(eyes2(:,1));
faceROI_save = [];
included_x_All_Save = [];
included_y_All_Save = [];
for t = 1:size(vidSin_out,3)
    
    firstFrame = vidSin_out(:,:,t);
    if round2 == 2
        if ndims(firstPoints1) ==3
            firstPoints_augmented =firstPoints1(t,:,:);
            firstPoints_augmented = permute(firstPoints_augmented, [2 3 1]);
        else
            firstPoints_augmented =firstPoints1;
        end
        
    else
        
       
    if ndims(firstPoints1) ==3
        firstPoints2 = firstPoints1(t, :,:); % if more than one frame.
        firstPoints2 = permute(firstPoints2, [2 3 1]);
    else
        % otherwise if only one frame
        firstPoints2 = firstPoints1;
    end

    % the whole face is here
    whole = [firstPoints2(1:68,1), firstPoints2(1:68,2)];

    % between eyebrows and chin
    eyebrows1 = [firstPoints2(18:22,1), firstPoints2(18:22,2)];
    eyebrows2 = [firstPoints2(23:27,1), firstPoints2(23:27,2)];
    eyebrows = [eyebrows1; eyebrows2];

    chin = [firstPoints2(1:17,1), firstPoints2(1:17,2)];

    eyebrowsWidth = max(eyebrows(:,1)) - min(eyebrows(:,1));
    % add some vertical height to include forehead
    forehead1 = [eyebrows(:,1), (eyebrows(:,2)-round(eyebrowsWidth/2))];
    forehead2 = [eyebrows(:,1), (eyebrows(:,2))];

    % plot([whole_face(:,1)], [whole_face(:,2)], 'r.');

    whole_face1 = [forehead1(:,1); chin(end:-1:1,1)];
    whole_face2 = [forehead1(:,2); chin(end:-1:1,2)];
    whole_face = [(whole_face1(:)) whole_face2];

    regionMask_whole_face = roipoly(firstFrame, whole_face(:,1), whole_face(:,2));
    % 
    % tstImg1 = im2double(firstFrame).*regionMask_whole_face;
    % figure, imshow(tstImg1)

    eyes = [firstPoints2(48:-1:37,1), firstPoints2(48:-1:37,2)];
    eyes1 = [firstPoints2(37:42,1), firstPoints2(37:42,2)];
    eyes2 = [firstPoints2(43:48,1), firstPoints2(43:48,2)];

    [valeye1, indeye1]= max(eyes1(:,2));
    [valeye3, indeye3]= min(eyes1(:,1));

    [valeye2, indeye2]= max(eyes2(:,2));
    [valeye4, indeye4]= max(eyes2(:,1));

    shiftDown = max(eyes(:,2))- min(eyes(:,2)); % about hte width of the eye = 20

    eyeROI = [[forehead2(:,1); valeye4; eyes2(indeye2,1); eyes1(indeye1,1); valeye3], ... 
        [forehead2(:,2); eyes1(indeye4,2)+shiftDown; valeye2+shiftDown; valeye1+shiftDown; eyes1(indeye3,2)+shiftDown ]];

    regionMask_eyes = roipoly(firstFrame, eyeROI(:,1), eyeROI(:,2));
    % remove eyes and mouth
    region_no_eyes = regionMask_whole_face - regionMask_eyes;
    mouth = [firstPoints2(49:60,1), firstPoints2(49:60,2)];
    regionMask_mouth = roipoly(firstFrame, mouth(:,1), mouth(:,2));
    % final face ROI / mask that includes the whole face with forehead 
    % but has eyes and mouth removed - noisy due to motion
    faceROI = region_no_eyes - regionMask_mouth;
%     faceROI_save{t} = faceROI;
    faceROI_save = faceROI;
    %% use triangulation to define small ROIs between landmarks
    firstPoints_augmented_x1 = [firstPoints2(:,1); forehead1(:,1)]; % add points to the forehead
    firstPoints_augmented_y1 = [firstPoints2(:,2); forehead1(:,2)];

    firstPoints_augmented1 = [firstPoints_augmented_x1 firstPoints_augmented_y1];
    shiftDown = max(eyes(:,2))- min(eyes(:,2)); % about hte width of the eye = 20

    eyeROI = [[forehead2(:,1); valeye4; eyes2(indeye2,1); eyes1(indeye1,1); valeye3], ... 
        [forehead2(:,2); eyes1(indeye4,2)+shiftDown; valeye2+shiftDown; valeye1+shiftDown; eyes1(indeye3,2)+shiftDown ]];

    regionMask_eyes = roipoly(firstFrame, eyeROI(:,1), eyeROI(:,2));
    % remove eyes and mouth
    region_no_eyes = regionMask_whole_face - regionMask_eyes;
    mouth = [firstPoints2(49:60,1), firstPoints2(49:60,2)];
    regionMask_mouth = roipoly(firstFrame, mouth(:,1), mouth(:,2));
    % final face ROI / mask that includes the whole face with forehead 
    % but has eyes and mouth removed - noisy due to motion
    faceROI = region_no_eyes - regionMask_mouth;
%     faceROI_save{t} = faceROI;
    faceROI_save = faceROI;
    %% use triangulation to define small ROIs between landmarks
    firstPoints_augmented_x1 = [firstPoints2(:,1); forehead1(:,1)]; % add points to the forehead
    firstPoints_augmented_y1 = [firstPoints2(:,2); forehead1(:,2)];

    firstPoints_augmented1 = [firstPoints_augmented_x1 firstPoints_augmented_y1];
    
%     firstPoints_augmented_x = firstPoints_augmented_x1([1:27, 32, 36, 69:78]); % remove small ROIs like nose, eyes and mouth
%     firstPoints_augmented_y = firstPoints_augmented_y1([1:27, 32, 36, 69:78]);
    
% keep only boundary of eyebrows and some face boundary points - less small
% triangles
    firstPoints_augmented_x = firstPoints_augmented_x1([1,4,7,10, 13, 17, 22, 23, 32, 36, 69, 73, 74, 78]); 
    firstPoints_augmented_y = firstPoints_augmented_y1([1,4,7,10, 13, 17, 22, 23, 32, 36, 69, 73, 74, 78]); 

    firstPoints_augmented = [firstPoints_augmented_x firstPoints_augmented_y];
    
    end
    % constraint on the max number of triangles or min size of each triangle
    TRI = delaunay(double(firstPoints_augmented(:,1)),double(firstPoints_augmented(:,2)));
%     figure, imshow(firstFrame), hold on, plot(firstPoints_augmented(:,1),firstPoints_augmented(:,2), 'g*')
%     triplot(TRI,double(firstPoints_augmented(:,1)),double(firstPoints_augmented(:,2)), 'g')

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
    imgHeight = size(firstFrame,1);
    imgWidth = size(firstFrame,2);
    % [img_x, img_y] = ind2sub([imgHeight imgWidth], 1:(imgHeight*imgWidth));
    [img_x, img_y] = ind2sub([imgHeight imgWidth], find(faceROI(:)));

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

        includedtr = inpolygon(img_y, img_x, round([tri_converted_x(tr,:,:) ...
            tri_converted_x(tr,1,1)]),round([tri_converted_y(tr,:,:) tri_converted_y(tr,1,1)] ));
        %sum(includedtr)

        areatr = polyarea(tri_converted_x(tr,:), tri_converted_y(tr,:));
        includedtr_non0 = find(includedtr);
        included_y = img_x(includedtr_non0);
        included_x = img_y(includedtr_non0);
    %     [included_x, included_y] = ind2sub([imgHeight imgWidth], includedtr_non0); %use find to save ccors of 
                                                                            % included
                                                                            % points, convert them to x, y
        included_x_All1{tr} = included_x; % save 
        included_y_All1{tr} = included_y;
        areatrAll1 = [areatrAll1; areatr];

        % remove triangles that are empty (mask) or that have less than 10 pixels total

%         if length(included_x) > 10 
%             count = count+1;
%             included_x_All{count} = included_x; % save 
%             included_y_All{count} = included_y;
%             areatrAll = [areatrAll; areatr];
%         else 
%             continue
%         end

    end

%% size threshold on the ROIs
% 
%         % area1 is larger than sum(included1) - what does it mean that more pixels
%         % are included than the size of the area itself? Does the area not include
%         % the corners defining the boundary, that's why it is off by 4 pixels?
% 
%         % include forehead and remove eyes and mouth
% 
%         % combine triangles if they are too small 
% 
%         % use the area defined between each triangle
% 
%         % check if area is less than 100 square pixels or other threshold
%         % if smaller combine it with the next triangle area
%     tr_1 = 1;
%     count = 0;
%     included_x_All_Final1 = {};
%     included_y_All_Final1 = {};
%     while tr_1 < length(included_x_All)
%         if length(included_x_All{tr_1}) < 100
%             count = count+1;
%             % combine with the previous ROI
%             included_x_All_Final1{count} = [included_x_All{tr_1}; included_x_All{tr_1+1}];
%             included_y_All_Final1{count} = [included_y_All{tr_1}; included_y_All{tr_1+1}];
%             tr_1 = tr_1+2;
%         else 
%             count = count+1;
%             included_x_All_Final1{count} = included_x_All{tr_1};
%             included_y_All_Final1{count} = included_y_All{tr_1};
%             tr_1 = tr_1+1;
%         end
%     end
% 
%     % repeat again to make sure that if 2 small ROIs were combined they 
%     tr_1 = 1;
%     count = 0;
%     included_x_All_Final = {};
%     included_y_All_Final = {};
%     while tr_1 < length(included_x_All_Final1)
%         if length(included_x_All_Final1{tr_1}) < 100
%             count = count+1;
%             % combine with the previous ROI
%             included_x_All_Final{count} = [included_x_All_Final1{tr_1}; included_x_All_Final1{tr_1+1}];
%             included_y_All_Final{count} = [included_y_All_Final1{tr_1}; included_y_All_Final1{tr_1+1}];
%             tr_1 = tr_1+2;
%         else 
%             count = count TRI = delaunay(double(firstPoints_augmented(:,+1;
%             included_x_All_Final{count} = included_x_All_Final1{tr_1};
%             included_y_All_Final{count} = included_y_All_Final1{tr_1};
%             tr_1 = tr_1+1;
%         end
%     end
% included_y_All_Save{t} = included_y_All_Final;
% included_x_All_Save{t} = included_x_All_Final;

included_y_All_Save{t} = included_y_All1;
included_x_All_Save{t} = included_x_All1;
%% combine neighboring ROIs
end % end for t

end % end function