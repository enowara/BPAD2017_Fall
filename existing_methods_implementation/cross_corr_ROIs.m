function rho = cross_corr_ROIs(Sj, N)   
% getRho function from Liu implementation
% Sj is a T x N PPG matrix for each video
% cross correlation between ROIs

% n = 1;
rho = [];
% for n = 1:N-1
for i = 1:N;
    for j = i:N; % figure out how to select different regions
    % generate C(N,2) combinations
    s_i = Sj(:,i);
    s_j = Sj(:,j);
    % for N choose k within pVec
    % s1
    % s2
    
    if i == j
        continue
    else 
        
    
    
    crossC = xcorr(s_i,s_j);   % multiply by pi and pj??? like a weighting factor??
    Y_crossC = fft(crossC);

    rhoTemp = max(abs(Y_crossC));
    rho = [rho rhoTemp]; % vector
    end
    end
end
end
% after goodness is applied to raw s signals, rho is the q vector

