

% generate new points interpolated between facial landmarks

% input 
% firstPoints_augmented1_init
% fullPath2Save
%%   % new point 1, between 73 and 74

x_temp = [firstPoints_augmented1_init(73,1), firstPoints_augmented1_init(74,1)];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(73,2), firstPoints_augmented1_init(74,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_1 = [lx(2), ly(2)];

%% new point 2, 15, 28 - between 69 and 1 

x_temp = [firstPoints_augmented1_init(69,1), firstPoints_augmented1_init(1,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(69,2), firstPoints_augmented1_init(1,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_2 = [lx(2), ly(2)];
np_15 = [lx(3), ly(3)];
np_28 = [lx(4), ly(4)];


%% new point 3, 16 - between 69 and 18 
x_temp = [firstPoints_augmented1_init(69,1), firstPoints_augmented1_init(18,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(69,2), firstPoints_augmented1_init(18,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_3 = [lx(2), ly(2)];
np_16 = [lx(3), ly(3)];

%% new point 4, 17 - between 70 and 19 
x_temp = [firstPoints_augmented1_init(70,1), firstPoints_augmented1_init(19,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(70,2), firstPoints_augmented1_init(19,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_4 = [lx(2), ly(2)];
np_17 = [lx(3), ly(3)];

%% new point 5, 18 - between 71 and 20 
x_temp = [firstPoints_augmented1_init(71,1), firstPoints_augmented1_init(20,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(71,2), firstPoints_augmented1_init(20,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_5 = [lx(2), ly(2)];
np_18 = [lx(3), ly(3)];

%% new point 6, 19 - between 72 and 21
x_temp = [firstPoints_augmented1_init(72,1), firstPoints_augmented1_init(21,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(72,2), firstPoints_augmented1_init(21,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_6 = [lx(2), ly(2)];
np_19 = [lx(3), ly(3)];

%% new point 7,20  - between 73 and 22
x_temp = [firstPoints_augmented1_init(73,1), firstPoints_augmented1_init(22,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(73,2), firstPoints_augmented1_init(22,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_7 = [lx(2), ly(2)];
np_20 = [lx(3), ly(3)];

%% new point 8,21, 29  - between np_1 and 28
x_temp = [np_1(1), firstPoints_augmented1_init(28,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [np_1(2), firstPoints_augmented1_init(28,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_8 = [lx(2), ly(2)];
np_21 = [lx(3), ly(3)];
np_29 = [lx(4), ly(4)];

%% new point 9,22  - between 74 and 23
x_temp = [firstPoints_augmented1_init(74,1), firstPoints_augmented1_init(23,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(74,2), firstPoints_augmented1_init(23,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_9 = [lx(2), ly(2)];
np_22 = [lx(3), ly(3)];

%% new point 10,23  - between 75 and 24
x_temp = [firstPoints_augmented1_init(75,1), firstPoints_augmented1_init(24,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(75,2), firstPoints_augmented1_init(24,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_10 = [lx(2), ly(2)];
np_23 = [lx(3), ly(3)];

%% new point 11,24  - between 76 and 25
x_temp = [firstPoints_augmented1_init(76,1), firstPoints_augmented1_init(25,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(76,2), firstPoints_augmented1_init(25,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_11 = [lx(2), ly(2)];
np_24 = [lx(3), ly(3)];

%% new point 12,25  - between 77 and 26
x_temp = [firstPoints_augmented1_init(77,1), firstPoints_augmented1_init(26,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(77,2), firstPoints_augmented1_init(26,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_12 = [lx(2), ly(2)];
np_25 = [lx(3), ly(3)];

%% new point 13,26  - between 78 and 27
x_temp = [firstPoints_augmented1_init(78,1), firstPoints_augmented1_init(27,1)];
lx = linspace(x_temp(1), x_temp(2), 4);

y_temp = [firstPoints_augmented1_init(78,2), firstPoints_augmented1_init(27,2)];
ly = linspace(y_temp(1), y_temp(2), 4);

np_13 = [lx(2), ly(2)];
np_26 = [lx(3), ly(3)];

%% new point 14, 27, 30  - between 78 and 17
x_temp = [firstPoints_augmented1_init(78,1), firstPoints_augmented1_init(17,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(78,2), firstPoints_augmented1_init(17,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_14 = [lx(2), ly(2)];
np_27 = [lx(3), ly(3)];
np_30 = [lx(4), ly(4)];

%% new point 31  - between 1 and 37
x_temp = [firstPoints_augmented1_init(1,1), firstPoints_augmented1_init(37,1)];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(1,2), firstPoints_augmented1_init(37,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_31 = [lx(2), ly(2)];

%% new point 32  - between 46 and 17
x_temp = [firstPoints_augmented1_init(46,1), firstPoints_augmented1_init(17,1)];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(46,2), firstPoints_augmented1_init(17,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_32 = [lx(2), ly(2)];

%% new point 36, 37, 37_2  - between 40 and 32
x_temp = [firstPoints_augmented1_init(40,1), firstPoints_augmented1_init(32,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(40,2), firstPoints_augmented1_init(32,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_36 = [lx(2), ly(2)];
np_37 = [lx(3), ly(3)];
np_37_2 = [lx(4), ly(4)];

%% new point 38, 39, 39_2  - between 43 and 36
x_temp = [firstPoints_augmented1_init(43,1), firstPoints_augmented1_init(36,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(43,2), firstPoints_augmented1_init(36,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_38 = [lx(2), ly(2)];
np_39 = [lx(3), ly(3)];
np_39_2 = [lx(4), ly(4)];

%% new point 33, 34, 35  - between 2 and np_37
x_temp = [firstPoints_augmented1_init(2,1), np_37(1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(2,2), np_37(2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_33 = [lx(2), ly(2)];
np_34 = [lx(3), ly(3)];
np_35 = [lx(4), ly(4)];


%% new point 40, 41, 42  - between np_39 and 16
x_temp = [np_39(1), firstPoints_augmented1_init(16,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [np_39(2), firstPoints_augmented1_init(16,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_40 = [lx(2), ly(2)];
np_41 = [lx(3), ly(3)];
np_42 = [lx(4), ly(4)];

%% new point 33, 34, 35  - between 2 and np_37
x_temp = [firstPoints_augmented1_init(3,1), np_37(1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(3,2), np_37(2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_33 = [lx(2), ly(2)];
np_34 = [lx(3), ly(3)];
np_35 = [lx(4), ly(4)];

%% new point 43, 44, 45  - between 3 and 32
x_temp = [firstPoints_augmented1_init(3,1), firstPoints_augmented1_init(32,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(3,2), firstPoints_augmented1_init(32,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_43 = [lx(2), ly(2)];
np_44 = [lx(3), ly(3)];
np_45 = [lx(4), ly(4)];

%% new point 46, 47, 48  - between 36 and 15
x_temp = [firstPoints_augmented1_init(36,1), firstPoints_augmented1_init(15,1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(36,2), firstPoints_augmented1_init(15,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_46 = [lx(2), ly(2)];
np_47 = [lx(3), ly(3)];
np_48 = [lx(4), ly(4)];

%% new point 52  - between 32 and 49
x_temp = [firstPoints_augmented1_init(32,1), firstPoints_augmented1_init(49,1)];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(32,2), firstPoints_augmented1_init(49,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_52 = [lx(2), ly(2)];

%% new point 53  - between 36 and 55
x_temp = [firstPoints_augmented1_init(36,1), firstPoints_augmented1_init(55,1)];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(36,2), firstPoints_augmented1_init(55,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_53 = [lx(2), ly(2)];

%% new point 49, 50, 51  - between 4 and np_52
x_temp = [firstPoints_augmented1_init(4,1), np_52(1)];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [firstPoints_augmented1_init(4,2), np_52(2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_49 = [lx(2), ly(2)];
np_50 = [lx(3), ly(3)];
np_51 = [lx(4), ly(4)];

%% new point 49, 50, 51  - between 14 and np_53
x_temp = [np_53(1), firstPoints_augmented1_init(14,1),];
lx = linspace(x_temp(1), x_temp(2), 5);

y_temp = [np_53(2), firstPoints_augmented1_init(14,2)];
ly = linspace(y_temp(1), y_temp(2), 5);

np_54 = [lx(2), ly(2)];
np_55 = [lx(3), ly(3)];
np_56 = [lx(4), ly(4)];

%% new point 57  - between 5 and 49
x_temp = [firstPoints_augmented1_init(5,1), firstPoints_augmented1_init(49,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(5,2), firstPoints_augmented1_init(49,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_57 = [lx(2), ly(2)];

%% new point 58  - between 55 and 13
x_temp = [firstPoints_augmented1_init(55,1), firstPoints_augmented1_init(13,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(55,2), firstPoints_augmented1_init(13,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_58 = [lx(2), ly(2)];

%% new point 59  - between 49 and 6
x_temp = [firstPoints_augmented1_init(49,1), firstPoints_augmented1_init(6,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(49,2), firstPoints_augmented1_init(6,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_59 = [lx(2), ly(2)];

%% new point 60  - between 60 and 7
x_temp = [firstPoints_augmented1_init(60,1), firstPoints_augmented1_init(7,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(60,2), firstPoints_augmented1_init(7,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_60 = [lx(2), ly(2)];

%% new point 61  - between 59 and 8
x_temp = [firstPoints_augmented1_init(59,1), firstPoints_augmented1_init(8,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(59,2), firstPoints_augmented1_init(8,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_61 = [lx(2), ly(2)];

%% new point 62  - between 58 and 9
x_temp = [firstPoints_augmented1_init(58,1), firstPoints_augmented1_init(9,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(58,2), firstPoints_augmented1_init(9,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_62 = [lx(2), ly(2)];

%% new point 63  - between 57 and 10
x_temp = [firstPoints_augmented1_init(57,1), firstPoints_augmented1_init(10,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(57,2), firstPoints_augmented1_init(10,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_63 = [lx(2), ly(2)];

%% new point 64  - between 56 and 11
x_temp = [firstPoints_augmented1_init(56,1), firstPoints_augmented1_init(11,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(56,2), firstPoints_augmented1_init(11,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_64 = [lx(2), ly(2)];

%% new point 65  - between 55 and 12
x_temp = [firstPoints_augmented1_init(55,1), firstPoints_augmented1_init(12,1),];
lx = linspace(x_temp(1), x_temp(2), 3);

y_temp = [firstPoints_augmented1_init(55,2), firstPoints_augmented1_init(12,2)];
ly = linspace(y_temp(1), y_temp(2), 3);

np_65 = [lx(2), ly(2)];

%% save
new_facial_points{1} = np_1;
new_facial_points{2} = np_2;
new_facial_points{3} = np_3;
new_facial_points{4} = np_4;
new_facial_points{5} = np_5;
new_facial_points{6} = np_6;
new_facial_points{7} = np_7;
new_facial_points{8} = np_8;
new_facial_points{9} = np_9;
new_facial_points{10} = np_10;

new_facial_points{11} = np_11;
new_facial_points{12} = np_12;
new_facial_points{13} = np_13;
new_facial_points{14} = np_14;
new_facial_points{15} = np_15;
new_facial_points{16} = np_16;
new_facial_points{17} = np_17;
new_facial_points{18} = np_18;
new_facial_points{19} = np_19;
new_facial_points{20} = np_20;

new_facial_points{21} = np_21;
new_facial_points{22} = np_22;
new_facial_points{23} = np_23;
new_facial_points{24} = np_24;
new_facial_points{25} = np_25;
new_facial_points{26} = np_26;
new_facial_points{27} = np_27;
new_facial_points{28} = np_28;
new_facial_points{29} = np_29;
new_facial_points{30} = np_30;

new_facial_points{31} = np_31;
new_facial_points{32} = np_32;
new_facial_points{33} = np_33;
new_facial_points{34} = np_34;
new_facial_points{35} = np_35;
new_facial_points{36} = np_36;
new_facial_points{37} = np_37;
new_facial_points{38} = np_38;
new_facial_points{39} = np_39;
new_facial_points{40} = np_40;

new_facial_points{41} = np_41;
new_facial_points{42} = np_42;
new_facial_points{43} = np_43;
new_facial_points{44} = np_44;
new_facial_points{45} = np_45;
new_facial_points{46} = np_46;
new_facial_points{47} = np_47;
new_facial_points{48} = np_48;
new_facial_points{49} = np_49;
new_facial_points{50} = np_50;

new_facial_points{51} = np_51;
new_facial_points{52} = np_52;
new_facial_points{53} = np_53;
new_facial_points{54} = np_54;
new_facial_points{55} = np_55;
new_facial_points{56} = np_56;
new_facial_points{57} = np_57;
new_facial_points{58} = np_58;
new_facial_points{59} = np_59;
new_facial_points{60} = np_60;

new_facial_points{61} = np_61;
new_facial_points{62} = np_62;
new_facial_points{63} = np_63;
new_facial_points{64} = np_64;
new_facial_points{65} = np_65;
new_facial_points{66} = np_37_2;
new_facial_points{67} = np_39_2;

save([fullPath2Save 'new_facial_points.mat'], 'np_1', 'np_2', 'np_3', 'np_4', 'np_5', 'np_6', 'np_7', ...
    'np_8', 'np_9', 'np_10', 'np_11', 'np_12', 'np_13', 'np_14', 'np_15', 'np_16', 'np_17', ...
    'np_18', 'np_19', 'np_20', 'np_21', 'np_22', 'np_23', 'np_24', 'np_25', 'np_26', 'np_27', ...
    'np_28', 'np_29', 'np_30', 'np_31', 'np_32', 'np_33', 'np_34', 'np_35', 'np_36', 'np_37', 'np_38', 'np_39', ...
    'np_37_2', 'np_39_2','np_40', 'np_41', 'np_42', 'np_43', 'np_44', 'np_49', 'np_50', 'np_51', ...
    'np_52', 'np_53', 'np_54', 'np_55', 'np_56', 'np_57', 'np_58', 'np_59', 'np_60', 'np_61', ...
    'np_62', 'np_63', 'np_64', 'np_65')

