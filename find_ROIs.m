% read in videos from big dataset and face coordinates
function [faceROI, face_ROIs] = find_ROIs(firstPoints1)
% first points have 68 landmarks for each frame, x and y coords

% for each frame:

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

%% defining forehead and cheeks
%     foreheadx = [forehead1(:,1); forehead2(end:-1:1,1)];
%     foreheady = [forehead1(:,2); forehead2(end:-1:1,2)];
%     
%     forehead = [foreheadx foreheady];
%    
%     foreheadMask = roipoly(firstFrame, forehead(:,1), forehead(:,2));
%     tstImgforehead = im2double(firstFrame).*foreheadMask;
%     
%     foreheadMasksubsampled = imresize(foreheadMask, [240 320]);
% 
% 
%     foreheadGrid = find(pointsList(t,:,2) < (max(forehead2(:,2)))); 
%     
%     Lcheeki = [firstPoints(1:9,1), firstPoints(1:9,2)];
%     LcheekY2 = find(pointsList(t,:,2) > round(min(Lcheeki(:,2))));  % FIXME!!
% 
%     LcheekX2 = find(pointsList(t,:,1) < round(max(Lcheeki(:,1))));
%     
%     RcheekX2 = find(pointsList(t,:,1) > round(max(Lcheeki(:,1))));
% 
%     Lcheek= intersect(LcheekX2,LcheekY2);
%     Rcheek = intersect(RcheekX2,LcheekY2);
%     
%% use triangulation to define small ROIs between landmarks

% constraint on the max number of triangles or min size of each triangle
TRI = delaunay(firstPoints2(:,1),firstPoints2(:,2));

% polyarea

% 
