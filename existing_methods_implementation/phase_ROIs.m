function Ph = phase_ROIs(Sj, N)   

% phase similarity between ROIs
% Sj is a T x N PPG matrix

% 2 similar signals ROIs should be in phase, check how true that is becuase
% they may have a lot of noise or delay

% from Wang et al. 2015


% n = 1;
Ph = [];
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

    Ph_ij = max(ifft(NCC));
    Ph = [Ph Ph_ij]; % vector
    end
    end
end
end
