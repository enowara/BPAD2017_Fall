function [faceROI, firstPoints_augmented1] = face_points_mask(firstPoints1, vidSin_out)
% input: 
% firstPoints1 - 68 detected landmarks
% vidSin_out - video frames

% output:
% faceROI - binary mask defining where the face is in the image, excluding
    % eyes and mouth
% firstPoints_augmented1 - facial landmarks with forehead added    
firstPoints_augmented1 = [];
for t = 1:size(vidSin_out,3)
    
    firstFrame = vidSin_out(:,:,t);
     
    if ndims(firstPoints1) ==3 % if points are defined for more than one frame
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
    
    % eyebrow ROI to be removed along with mouth and eyes

    % add and subtract one pixel to define a small area

    eyebrowsROIx_start = [eyebrows(:,2)] - 1; 
    eyebrowsROIx_end = [eyebrows(:,2)] + 2; 
    
    eyebrowsROIy_start = [eyebrows(:,1)] - 1; 
    eyebrowsROIy_end = [eyebrows(:,1)] + 2;    
   
    eyebrowsROI = [eyebrowsROIy_start:eyebrowsROIy_end, eyebrowsROIx_start:eyebrowsROIx_end];
    
    regionMask_eyebrows = roipoly(firstFrame, eyebrowsROI(:,1), eyebrowsROI(:,2));

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
    
    regionMask_noEyebrows = region_no_eyes - regionMask_eyebrows;
    
    mouth = [firstPoints2(49:60,1), firstPoints2(49:60,2)];
    regionMask_mouth = roipoly(firstFrame, mouth(:,1), mouth(:,2));
    
    % final face ROI / mask that includes the whole face with forehead 
    % but has eyes and mouth removed - noisy due to motion
    faceROI = regionMask_noEyebrows - regionMask_mouth;
%     figure, imshow(faceROI)
%     figure, imshow(uint8(double(faceROI).*double(firstFrame)))
%     faceROI_save{t} = faceROI; % if many frames, save all masks


    %% dilate
%     use dilation to remove small remnants of removed ROIs 
    se = strel('ball',5,5); % Create a nonflat ball-shaped structuring element.
    imDil = imdilate((abs(1-faceROI)),se);
%     figure, imshow(imDil, [])
    imDil = imDil-min(imDil(:));
    imDil = logical(imDil);
%         figure, imshow(1-imDil, [])
finalMask = double(1-imDil);
finalImg = finalMask.*double(firstFrame);
% figure, imshow(uint8(finalImg), [])
    %% use triangulation to define small ROIs between landmarks
    firstPoints_augmented_x1 = [firstPoints2(:,1); forehead1(:,1)]; % add points to the forehead
    firstPoints_augmented_y1 = [firstPoints2(:,2); forehead1(:,2)];

    firstPoints_augmented1_t = [firstPoints_augmented_x1 firstPoints_augmented_y1];
    firstPoints_augmented1 = [firstPoints_augmented1; firstPoints_augmented1_t];
    % if many frames, save all points
end

end