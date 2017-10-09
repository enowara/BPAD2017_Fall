function [region1] = pnts2ROI(ROI1_list_points, facial_points)
% given a list of x, y points create a ROI which contains those points

    x1 = [facial_points(ROI1_list_points, 1)];
    y1 = [facial_points(ROI1_list_points, 2)];
    region1b = boundary(x1,y1);
    region1 = [x1(region1b), y1(region1b)];

end