function small_facialRegions = split_to_100_smallROIs(facialRegions, blockSizeR, blockSizeC, firstFrame)

% input
% blockSizeR = size of the desired block in ROI, row dim
% blockSizeC

% for each big facial ROI
    for i = 1:length(facialRegions)
        % take all points defining that ROI
        one_ROI = facialRegions{i}; % points defining the ROI
        % part of the frame containing points of interest
        one_ROI_img = poly2mask(one_ROI(:,1), one_ROI(:,2), size(firstFrame,1), size(firstFrame,2));
        
        rows = max(one_ROI(:,1)) - min(one_ROI(:,1));
        columns = max(one_ROI(:,2)) - min(one_ROI(:,2));

%         blockSizeR = 10; % Rows in block.
%         blockSizeC = 10; % Columns in block.

        % Figure out the size of each block in rows.
        % Most will be blockSizeR but there may be a remainder amount of less than that.
        
        % number of ROIs:
        wholeBlockRows = floor(rows / blockSizeR);
        blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
        % Figure out the size of each block in columns.
        wholeBlockCols = floor(columns / blockSizeC);
        blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];
        
        count = 0;
        for row = floor(min(one_ROI(:,1))) : blockSizeR : floor(max(one_ROI(:,1))) 
            for col = floor(min(one_ROI(:,2))) : blockSizeC : floor(max(one_ROI(:,2))) 
 
%                 subROIpoints{i,count} = [pnts; [row col]];
                
                row1 = row;
                row2 = row1 + blockSizeR - 1;
                row2 = min( floor(max(one_ROI(:,1))) , row2);
                col1 = col;
                col2 = col1 + blockSizeC - 1;
                col2 = min(floor(max(one_ROI(:,2))) , col2);
                
                % skip if the ROI is comning out of the boundary of that
                % region
                if length(row1:row2) <= blockSizeR-1 ||  length(col1:col2) <= blockSizeR-1
%                     rowcount
%                     col
%                     break
                    continue
                else
                oneBlock = one_ROI_img(col1:col2, row1:row2);
                % want to average all pixels inside the little oneBlock
                
                % make sure that not all points are outside of the ROI
                if sum(oneBlock(:)) == 0
%                     hold on, 
%                     plot([row1:row2], [col1:col2], '*b')
%                     drawnow
%                     pause()
                    
                    % save the smaller subROIs
%                     list_points_icr = [col1:col2; row1:row2]';
%                     temp = 
%                     subROI = pnts2ROI(list_points_icr, pnts);

                    
%                     hold on, plot(min([row1:row2]),min([col1:col2]), '+b'), ...
%                     plot(max([row1:row2]),max([col1:col2]), '+b')

                    

%                     for k = 1:size(subROIpoints,2)
%                         temp_pnts = subROIpoints{i,k};
%                     hold on, plot(temp_pnts(:,1), temp_pnts(:,2), '*g')
%                     % pause()
%                     end

                else
                    count = count+1;
                    small_facialRegions{i,count} = [[col1:col2]' [row1:row2]']; % [row col]
                    if isempty( [[col1:col2]' [row1:row2]'])
                        break
                    end
%                     temp= subROIpoints{i,count};
%                     one_ROI_img(temp(:,1), temp(:,2));

%                 figure, imshow(firstFrame), 
%                 hold on, 
%                 plot([row1:row2], [col1:col2], '*y')
%                 drawnow
%                 pause()
                end
            end
        end
        end

    end

end


