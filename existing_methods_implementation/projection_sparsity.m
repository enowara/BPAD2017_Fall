% sparsity projecttion: use sparse FFT code to project a ROIs signal into a
% space that requires ROIs are sparse:

% F' = F * P, F is a feature matrix and P is a learned projection matrix,
% F' is the new projected feature matrix

% example of an objective function: min over P : y(F, Y, P), where Y is the
% ground truth (labels) vector