facialRegions

N = length(facialRegions);
for i = 1:N
    pnts_plot = facialRegions{i};
    A(i) = polyarea(pnts_plot(:,1), pnts_plot(:,2));
    
    
    for r = 1:size(pnts_plot,1) - 1 % ignore the last row which should be the same as 1st
        xy1 = pnts_plot(r,:);
        xy2 = pnts_plot(r+1,:);
        dist(r) = pdist([xy1; xy2], 'euclidean'); % length of each side of polygon
        
%         interpolate such that each line segment will be 20 pixels or less?

% if a line is longer than 20 pixels, split into smaller or split in half

        xx = [xy1(1) xy2(1)];
        yy = [xy1(2) xy2(2)];

        num_Segments(r) = ceil(dist(r)/20); % ceil or floor? 
        lx{r} = linspace(xx(1), xx(2), num_Segments(r)+2);
        ly{r} = linspace(yy(1), yy(2), num_Segments(r)+2);

%         xy_new1 = [lx{r}(1) ly{r}(1)]
%         xy_new2 = [lx{r}(2) ly{r}(2)] 
% 
%         dist_new(r) = pdist([xy_new1; xy_new2], 'euclidean'); 

        x_new_r = lx{r};
        y_new_r = ly{r};

        xy_new_r = [x_new_r' y_new_r'];

        plot(xy_new_r(:,1), xy_new_r(:,2), '*r')
        
        % the above code divides each line into segents
        
        % for now divides based on the length of the line but it should be
        % fixed - always divide forehead into n1 ROIs, etc. 
        
        % to find 
        
        
        
    end
end