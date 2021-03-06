function [pointsResizedAll] = dlib2FacialPoints(imgFolder,img_names, pointsFile)
% converting Dlib saved points to facial Landmark poionts

% input:
% imgFolder1
% img_names1
% pointsFile1

% output:
% pointsResizedAll1

% % if not ordered well:
% for i =1: length(img_names1)
%     imgCells{i} = img_names1(i).name;  
% end
% 
% [cs,index] = sort_nat(imgCells,'ascend');
% img_names = cs;
%read in the points from txt file for each img
% imgFolder = '/media/ewa/Data/EwaPPGdataCollection/NewerHandvsFixed/EwaLiveCamFixed/cam1/';
% img_names = dir([imgFolder '/' '*.png']);
% pointsFile = '/home/ewa/Documents/dlib-19.1/examples/build/PointsSavedPPGtest2.txt';
pointsResizedAll = [];
points = dlmread([pointsFile], ',');
%k = 68 % number of points per face
noFace = 0;
extraFaces = 0;         % # of additional faces - # of missing faces/frames
lastFrame = floor(size(points,1)/69)-1;        % last image to examine
if lastFrame <= 0 
    lastFrame = 0;
end
i = 0;                % first image to examine
prevFace = zeros(69, 2);    % stores location of face from previous frame
headerFlag = 1300;      % value in points text file to signify header

% find first image and calculate extraFaces until then
% cnt = 0;
% while(1)
%     header = points((cnt)*69+1,:);
%     extraFaces = cnt - header(1);       % extraFaces is # of headers - frame #
%     if header(1) == i && header(2) == headerFlag    % found header for image i
%         break
%     end
%     if header(1) > i && header(2) == headerFlag     % went beyond image i... image i does not exist
%         disp(['Image/Face does not exist for ' num2str(i)])
%         break
%     end
%     cnt = cnt+1;
% end

while (i < lastFrame + 1) % should be -1 but getting rid of the 
                                     %last one just in case it didn't get fully saved
    %(length(img_names)-1) % i = 0 is the first image
    
    
    % read points for each i'th img
   % if (points(i+1,3) == 1);
   i;
        pointsPerImgAll = points(((i+extraFaces)*69 + 1):((i+extraFaces)*69+69),:); % i is index of the 68 points
        
        frameNum = pointsPerImgAll(1,1);
        
        % Check if frame/face does not exist
%         if pointsPerImgAll(1,2) == headerFlag       % it's a header
%             if frameNum ~= i    % incorrect frame # means current frame does not exist
%                 extraFaces = extraFaces - frameNum + i;   % decrement extraFaces by number of missing frames 
%                 i = frameNum;       % skip ahead to next existing frame
%             end
%         end
        
        % Check if there are multiple faces
%         while(1)
%             nextHeader = points((i+1+extraFaces)*69+1,:);
%             if nextHeader(1) == i && nextHeader(2) == headerFlag
%                 extraFaces = extraFaces + 1;
%                 % you have another face to read
%                 tempFace = points(((i+1+extraFaces)*69 + 1):((i+1+extraFaces)*69+69),:);
%                 % if new face read in was actually the correct face
%                 if abs(tempFace(35,1)-prevFace(35,1)) < abs(pointsPerImgAll(35,1)-prevFace(35,1))
%                     pointsPerImgAll = tempFace;     % save new face read instead
%                 end
%             else
%                 break
%             end
%         end
        
        prevFace = pointsPerImgAll;         % call current face the previous face for next iter

        
        % read i'th img
%         img_name = img_names{i}; %img_names((i+1)).name;
        img_path = fullfile(imgFolder, img_names);%images_folder_path, image_name);
        img = imread(img_path);
            
        pointsPerImg1 = pointsPerImgAll(2:69,1);
        pointsPerImg2 = pointsPerImgAll(2:69,2);
        %realimg = pointsPerImgAll(:,3);
        pointsPerImg = [pointsPerImg1 pointsPerImg2]; % 68 points per img
 
    %resize the image to match the points 
    numRow = size(img,1)*2+1;
    numCol = size(img,2)*2+2; 
    imgResized = imresize(img, [numRow numCol]);
    %or resize the points to match the original img?
    pointsResized(:,1) = (pointsPerImg(:,1).* (1/2) - 1);
    pointsResized(:,2) = (pointsPerImg(:,2).* (1/2) -2); 
    % 
%     figure, imshow(imgResized);
%     hold on;
%     plot([pointsPerImg(:,1)], [pointsPerImg(:,2)], 'g.');
%         title(img_name)
%     pause(2)
%     close

%     figure, imshow(img);
%     hold on;
%     plot([pointsResized(:,1)], [pointsResized(:,2)], 'g.');
%     title(img_name)
%     pause(2)
%     close


    i = i + 1;
    pointsResizedAll = [pointsResizedAll; pointsResized];
end
% dLibPointsTrainReal = pointsResizedAll;
% save('dLibPointsTrainReal.mat', 'dLibPointsTrainReal')
end
