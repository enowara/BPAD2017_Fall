function Entropy = entropy_ROIs(Sj, N)   

% entropy in each ROI's spectrum, live should be less disordered than
% attack, or it should have the same amount of noise plus a clean peak

% n = 1;
Entr = [];
% for n = 1:N-1
for i = 1:N;
   s_i = Sj(:,i);
    
   % normalize the signals: subtract the mean and divide by std
   s_i = (s_i - mean(s_i)) / std(s_i);
   P=(abs(fft(s_i)).^2);
   %Normalization
   d=P(:);
   d=d/sum(d);

   %Entropy Calculation
   logd = log2(d + 1e-12);
   Entropy(i) = -sum(d.*logd)/log2(length(d));
    
end
