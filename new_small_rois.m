function ROI_list_points_time = new_small_rois(tracked_points_init) 
% small rois from new facial points 

% the output is ROI_list_points, where each cell contains the x and y
% coords of corners defining the ROIs

% rename for short: 

for t = 1:size(tracked_points_init,1)
% repeat for each frame, where old and new facial points were tracked
op = tracked_points_init(t,1:78,:); % old points
np = tracked_points_init(t,79:145,:);
op = permute(op, [2 3 1]);
np = permute(np, [2 3 1]);
% ROI_list_points{1} = [np{2}; np{3}; op(69,:)];
% ROI_list_points{2} = [np{3}; np{4}; op(70,:); op(69,:)];
ROI_list_points{1} = [np(2,:); np(4,:); op(70,:); op(69,:)];
ROI_list_points{2} = [];
ROI_list_points{3} = [np(4,:); np(5,:); op(71,:); op(70,:)];
ROI_list_points{4} = [np(5,:); np(6,:); op(72,:); op(71,:)];
ROI_list_points{5} = [np(6,:); np(7,:); op(73,:); op(72,:)];
ROI_list_points{6} = [np(7,:); np(8,:); np(1,:); op(73,:)];
ROI_list_points{7} = [np(1,:); op(74,:); np(9,:); np(8,:)];
ROI_list_points{8} = [np(9,:); np(10,:); op(75,:); op(74,:)];
ROI_list_points{9} = [np(10,:); np(11,:); op(76,:); op(75,:)];
ROI_list_points{10} = [np(11,:); np(12,:); op(77,:); op(76,:)];

% ROI_list_points{11} = [np{12}; np{13}; op(78,:); op(77,:)];
% ROI_list_points{12} = [np{13}; np{14}; op(78,:)];
ROI_list_points{11} = [np(12,:); np(14,:); op(78,:); op(77,:)];
ROI_list_points{12} = [];
% ROI_list_points{13} = [np{15}; np{16}; np{3}; np{2}];
% ROI_list_points{14} = [np{16}; np{17}; np{4}; np{3}];
ROI_list_points{13} = [np(15,:); np(17,:); np(4,:); np(2,:)];
ROI_list_points{14} = [];
ROI_list_points{15} = [np(17,:); np(18,:); np(5,:); np(4,:)];
ROI_list_points{16} = [np(18,:); np(19,:); np(6,:); np(5,:)];
ROI_list_points{17} = [np(19,:); np(20,:); np(7,:); np(6,:)];
ROI_list_points{18} = [np(20,:); np(21,:); np(8,:); np(7,:)];
ROI_list_points{19} = [np(21,:); np(22,:); np(9,:); np(8,:)];
ROI_list_points{20} = [np(22,:); np(23,:); np(10,:); np(9,:)];

ROI_list_points{21} = [np(23,:); np(24,:); np(11,:); np(10,:)];
ROI_list_points{22} = [np(24,:); np(25,:); np(12,:); np(11,:)];
% ROI_list_points{23} = [np{25}; np{26}; np{13}; np{12}];
% ROI_list_points{24} = [np{26}; np{27}; np{14}; np{13}];
ROI_list_points{23} = [np(25,:); np(27,:); np(14,:); np(12,:)];
ROI_list_points{24} = [];
% ROI_list_points{25} = [np{28}; op(18,:); np{16}; np{15}];
% ROI_list_points{26} = [op(18,:); op(19,:); np{17}; np{16}];
ROI_list_points{25} = [np(28,:); op(19,:); np(17,:); np(15,:)];
ROI_list_points{26} = [];
ROI_list_points{27} = [op(19,:); op(20,:); np(18,:); np(17,:)];
ROI_list_points{28} = [op(20,:); op(21,:); np(19,:); np(18,:)];
ROI_list_points{29} = [op(21,:); op(22,:); np(20,:); np(19,:)];
ROI_list_points{30} = [op(22,:); np(29,:); np(21,:); np(20,:)];

ROI_list_points{31} = [np(29,:); op(23,:); np(22,:); np(21,:)];
ROI_list_points{32} = [op(23,:); op(24,:); np(23,:); np(22,:)];
ROI_list_points{33} = [op(24,:); op(25,:); np(24,:); np(23,:)];
ROI_list_points{34} = [op(25,:); op(26,:); np(25,:); np(24,:)];
ROI_list_points{35} = [op(26,:); op(27,:); np(26,:); np(25,:)];
ROI_list_points{36} = [op(27,:); np(30,:); np(27,:); np(26,:)];
% ROI_list_points{37} = [op(1,:); np{31}; op(18,:); np{28}];
% ROI_list_points{38} = [np{31}; op(37,:); op(18,:)];
% ROI_list_points{39} = [op(18,:); op(37,:); op(19,:)];
ROI_list_points{37} = [op(1,:); op(37,:); op(19,:); np(28,:)];
ROI_list_points{38} = [];
ROI_list_points{39} = [];
ROI_list_points{40} = [op(37,:); op(38,:); op(20,:); op(19,:)];

ROI_list_points{41} = [op(38,:); op(39,:); op(21,:); op(20,:)];
ROI_list_points{42} = [op(21,:); op(22,:); op(40,:); op(39,:)];
ROI_list_points{43} = [op(40,:); op(28,:); np(29,:); op(22,:)];
ROI_list_points{44} = [op(28,:); op(43,:); op(23,:); np(29,:)];
ROI_list_points{45} = [op(43,:); op(44,:); op(24,:); op(23,:)];
ROI_list_points{46} = [op(44,:); op(45,:); op(25,:); op(24,:)];
ROI_list_points{47} = [op(45,:); op(46,:); op(26,:); op(25,:)];
% ROI_list_points{48} = [op(46,:); op(27,:); op(26,:)];
% ROI_list_points{49} = [op(46,:); np{32}; op(27,:)];
% ROI_list_points{50} = [np{32}; op(17,:); np{30}; op(27,:)];
ROI_list_points{48} = [op(46,:); op(17,:); np(30,:); op(26,:)];
ROI_list_points{49} = [];
ROI_list_points{50} = [];

ROI_list_points{51} = [op(2,:); np(33,:); np(31,:); op(1,:)];
ROI_list_points{52} = [np(33,:); np(34,:); op(37,:); np(31,:)];
ROI_list_points{53} = [np(34,:); np(35,:); op(41,:); op(37,:)];
ROI_list_points{54} = [np(35,:); np(37,:); op(40,:); op(41,:)];
ROI_list_points{55} = [np(36,:); op(29,:); op(28,:); op(40,:)];
ROI_list_points{56} = [np(37,:); op(30,:); op(29,:); np(36,:)];
ROI_list_points{57} = [op(29,:); np(38,:); op(43,:); op(28,:)];
ROI_list_points{58} = [op(30,:); np(39,:); np(38,:); op(29,:)];
ROI_list_points{59} = [np(39,:); np(40,:); op(48,:); op(43,:)];
ROI_list_points{60} = [np(40,:); np(41,:); op(46,:); op(48,:)];

ROI_list_points{61} = [np(41,:); np(42,:); np(32,:); op(46,:)];
ROI_list_points{62} = [np(42,:); op(16,:); op(17,:); np(32,:)];
% ROI_list_points{63} = [op(3,:); np{43};  np{33}; op(2,:)];
% ROI_list_points{64} = [np{43}; np{44};  np{34}; np{33}];
ROI_list_points{63} = [op(3,:); np(44,:);  np(34,:); op(2,:)];
ROI_list_points{64} = [];
% ROI_list_points{65} = [np{44}; np{45};  np{35}; np{34}];
% ROI_list_points{66} = [np{45}; op(32,:);  np{37}; np{35}];
ROI_list_points{65} = [np(44,:); op(32,:); np(37,:); np(34,:)];
ROI_list_points{66} = [];
ROI_list_points{67} = [np(66,:); op(31,:);  op(30,:); np(37,:)];
ROI_list_points{68} = [op(32,:); op(33,:); op(31,:);  np(66,:)];
ROI_list_points{69} = [op(31,:); np(67,:); np(39,:); op(30,:)];
ROI_list_points{70} = [op(33,:); op(36,:); np(67,:); op(31,:)];

ROI_list_points{71} = [op(36,:); np(46,:); np(40,:); np(39,:)]; 
ROI_list_points{72} = [np(46,:); np(47,:); np(41,:); np(40,:)];
ROI_list_points{73} = [np(47,:); np(48,:); np(42,:); np(41,:)];
ROI_list_points{74} = [np(48,:); op(15,:); op(16,:); np(42,:)];
ROI_list_points{75} = [op(4,:); np(49,:); np(43,:); op(3,:)];
ROI_list_points{76} = [np(49,:);  np(50,:);  np(44,:);  np(43,:)];
ROI_list_points{77} = [np(50,:);  np(51,:);  np(45,:);  np(44,:)];
ROI_list_points{78} = [np(51,:);  np(52,:);  op(32,:);  np(45,:)];
ROI_list_points{79} = [np(52,:); op(52,:); op(34,:); op(32,:)];
ROI_list_points{80} = [op(52,:); np(53,:); op(36,:); op(33,:)];

ROI_list_points{81} = [np(53,:); np(54,:); np(46,:); op(36,:)];
ROI_list_points{82} = [np(54,:); np(55,:); np(47,:); np(46,:)];
ROI_list_points{83} = [np(55,:); np(56,:); np(48,:); np(47,:)];
ROI_list_points{84} = [np(56,:); op(14,:); op(15,:); np(48,:)];
ROI_list_points{85} = [op(5,:); np(57,:); np(50,:); op(4,:)];
ROI_list_points{86} = [np(57,:); op(49,:); np(52,:); np(50,:)];
ROI_list_points{87} = [op(55,:); np(58,:); np(55,:); np(53,:)];
ROI_list_points{88} = [np(58,:); op(13,:); op(14,:); np(55,:)];
ROI_list_points{89} = [op(5,:); op(6,:); op(49,:);];
ROI_list_points{90} = [np(59,:); np(60,:); op(60,:); op(49,:)];

ROI_list_points{91} = [op(6,:); op(7,:); np(60,:); np(59,:)];
ROI_list_points{92} = [np(60,:); np(61,:); op(59,:); op(60,:)];
ROI_list_points{93} = [op(7,:); op(8,:); np(61,:); np(60,:)];
ROI_list_points{94} = [np(61,:); np(62,:); op(58,:); op(59,:)];
ROI_list_points{95} = [op(8,:); op(9,:); np(62,:); np(61,:)];
ROI_list_points{96} = [np(62,:); np(63,:); op(57,:); op(58,:)];
ROI_list_points{97} = [op(9,:); op(10,:); np(63,:); np(62,:)];
ROI_list_points{98} = [np(63,:); np(64,:); op(56,:); op(57,:)];
ROI_list_points{99} = [op(10,:); op(11,:); np(64,:); np(63,:)];
ROI_list_points{100} = [np(64,:); np(65,:); op(55,:); op(56,:)];

ROI_list_points{101} = [op(11,:); op(12,:); np(65,:); np(64,:)];
ROI_list_points{102} = [op(12,:); op(13,:); op(55,:)];% np{58}; np{65}];

ROI_list_points_time{t} = ROI_list_points;
end % end t

% N = length(ROI_list_points);
% for n = 1:N
%     ROI_list_points_i = ROI_list_points{n};
%     if isempty(ROI_list_points_i) == 0 
% 
% %     regioni_temp = pnts2ROI(ROI_list_points_i, facial_points);
% %     x1 = [ROI_list_points_i(:, 1); ROI_list_points_i(1, 1)];
% %     y1 = [ROI_list_points_i(:, 2); ROI_list_points_i(1, 2)];
% %     region1b = boundary(round(x1)',round(y1)');
% %         
% %     
% %     regioni_temp = [x1(region1b), y1(region1b)];
% %     
% %     % to avoid problems where the ROI is folded into triangles instead of
% %     % rectangles, remove repeating points except for the first and last one
% %     regioni_2 = unique(regioni_temp(2:end-1,:), 'rows', 'stable');
% %     regioni = [regioni_temp(1,:); regioni_2; regioni_temp(end,:)];
% %     to_remove = (withoutRepeating, regioni_temp(2:end-1,:));
%     
%     facialRegions{n} = ROI_list_points_i;
%     pnts_plot_temp = facialRegions{n};
%     pnts_plot1 = [pnts_plot_temp(:,1); pnts_plot_temp(1,1)];
%     pnts_plot2 = [pnts_plot_temp(:,2); pnts_plot_temp(1,2)];
%     pnts_plot = [pnts_plot1 pnts_plot2];
%     A(n) = polyarea(pnts_plot(:,1), pnts_plot(:,2));
%     plot(pnts_plot(:,1), pnts_plot(:,2), 'LineWidth', 2)
%     title(num2str(n))
%     pause()
%     else
%         continue
%     end
% end

