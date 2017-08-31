% read in 
for f = 1:2
%     folderMain = '/media/ewa/SH/3dmadDirectories/';
%     folder = ['Data0' num2str(f) '/']; 
%     fileNameList = dir([[folderMain folder] '*C.avi']);
folderMain =  '/media/ewa/SH/DatasetsAntiSpoof/3dmadDirectories/Data01Keep/';
saveFolder =  '/media/ewa/SH/DatasetsAntiSpoof/3dmadDirectories/Data01Keep_frames/';
mkdir(saveFolder)

% % mkdir(['3DMAD1stFrame/Data0' num2str(f) '/'])
% if f ==1
%     folder = 'test/real/';
% end 
% if f ==2
%     folder = 'test/attack/';
% end 

% if f ==3
%     folder = 'train/attack/hand/';
% end 
fileNameList = dir([[folderMain] '*.avi']);
    % the first 5 frames are rotated right and the next five left, and so
    % on, so rotate all by flipping x and y coords and then flip upside
    % down the first five, dont flip the next 5 etc.  <-- this didn't work
    
    for m = 1:length(fileNameList) % al videos
%        for m = (10*mm+1):(10*mm+5) % the part that needs rotation
%         for m = (10*mm+6):(10*mm+10) % the part that does not need rotation
            vidName = fileNameList(m).name;
           
            v = VideoReader([folderMain vidName]);
            videoLength = v.Duration;
            videoRate = v.FrameRate;
            numFrame = videoLength*videoRate;
            width = v.Width;
            height = v.Height; 

            frames = read(v);

            vg = frames(:,:,2,:);
            vg = permute(vg,[1,2,4,3]);
            
%             only for replay mobile
%             if size(vg,1) == 720
%                 vg = permute(vg,[2,1,3]);
%             end
            
%             firstFrame = imrotate(vg(:,:,1), 180);
            firstFrame = vg(:,:,1);
            
% imwrite(firstFrame, ['IDAP1stFrameNew/' num2str(f) '/' vidName '.png']);

    imwrite(firstFrame, [saveFolder  '/' vidName '.png']);
    end
end
% end
