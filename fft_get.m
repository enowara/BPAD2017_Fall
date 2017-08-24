% compute a fft spectrum magnitude squared of a PPG signal, if PPG is not a
% time vector, average it spatially first

% Input:
% PPG1 - PPG matrix T x R or T x 1 time vector after it has been averaged
% Fps1 - frame rate of video

% Output:
% freq1 - frequency bins vector
% P1 - fft spectrum magnitude

function [freq1, P1] = fft_get(PPG1, Fps1)
% debugging
% PPG1 = PPG_filt;
% Fps1 = Fps;
    L = size(PPG1,1) * 100;
    x = mean(PPG1,2);
    hannWin = hann(length(x)); % hanning window
    Y = fft(x.*hannWin, L); % zero pad for better frequency resolution
    
    P2 = abs(Y/L).^2; % maginitude, squared
    P1 = P2(1:floor(L/2+1)); % one-sided spectrum
    P1(2:end-1) = 2*P1(2:end-1); % multiply by 2 to keep the same scale (only looking at half of the spectrum) 
    
%     freq1 = Fps1*(0:(L/2))/L;
%     freq1 = (0:(L*10-1))*Fps1/L*10;
    freq1 = (0:(L/2))*Fps1/L;
%     freq1=Fps1*(0:1/L:(0.5));
%     figure, plot(freq1, P1)

end

 
