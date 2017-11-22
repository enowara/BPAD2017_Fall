function small_idx_map = map_snakkROIs_idx_to_facialROI(small_facialRegions)

% for each row (Big facial ROI) find how many cells are non zero
% keep that number
% the following indices are a part of the next big facial ROI
% up to the point that they also become empty
count = 0;
for i = 1:size(small_facialRegions,1)
    idx_List_i = [];
    for k = 1:size(small_facialRegions,2)
        tempROIs = small_facialRegions{i,k};
        if isempty(tempROIs)
            continue
        else
            count = count+1;
            idx_List_i = [idx_List_i count];
        end
    end
    small_idx_map{i} = idx_List_i;
end