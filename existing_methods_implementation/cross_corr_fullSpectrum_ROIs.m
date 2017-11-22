function Y_C = cross_corr_fullSpectrum_ROIs(Sj, N)   
% getRho function from Liu implementation
% Sj is a T x N PPG matrix for each video
% cross correlation between ROIs

% n = 1;
Y_C = [];
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

%     rhoTemp = max(abs(Y_crossC));
    Y_C = [Y_C Y_crossC]; % vector
    end
    end
end

figure, 
for k = 1:49
    subplot(7,7,k)
plot(abs(Y_fake(:,k)), 'r')
hold on 
plot(abs(Y_motion(:,k)), 'b')
plot(abs(Y_live(:,k)), 'g')

end
% after goodness is applied to raw s signals, rho is the q vector

