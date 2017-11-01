
function Entr = entropy_cross_ROIs(Sj, N)   

% entropy of spectrum of correlation of 2 signals
% Sj is a T x N PPG matrix

% 2 similar signals ROIs should be in phase, check how true that is becuase
% they may have a lot of noise or delay

% from Wang et al. 2015

% n = 1;
Entr = [];
% for n = 1:N-1
for i = 1:N;
    for j = i:N; % figure out how to select different regions
    if i == j
        continue
    else 
        
    % generate C(N,2) combinations
    s_i = Sj(:,i);
    s_j = Sj(:,j);
    
    % normalize the signals: subtract the mean and divide by std
    s_i = (s_i - mean(s_i)) / std(s_i);
    s_j = (s_j - mean(s_j)) / std(s_j);
    
    NCC1 = fft(s_i).*conj(fft(s_j));
    NCC2 = norm(fft(s_i).*conj(fft(s_j)),2); % L2 norm
    
    NCC = NCC1/NCC2;

    Entr_ij = sum(NCC.*log(NCC))/(log(300-30)); % frequency range: 0.5 - 5 Hz, 30- 300 bpm
    Entr = [Entr Entr_ij]; % vector
    end
    end
end
end

