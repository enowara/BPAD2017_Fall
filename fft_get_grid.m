function [freq1, Pk] = fft_get_grid(PPG1, Fps1)
% debugging
% PPG1 = PPG_filt;
% Fps1 = Fps;

    L = size(PPG1,1) * 100;
    freq1 = Fps1*(0:(L/2))/L;
    for k = 1:size(PPG1,2)
        x = PPG1(:,k);
        hannWin = hann(length(x));
        Y = fft(x.*hannWin, L); % zero pad

        P2 = abs(Y/L).^2; % maginitude, squared
        P1 = P2(1:L/2+1); % one-sided spectrum
        P1(2:end-1) = 2*P1(2:end-1); % multiply by 2 to keep the same scale (only looking at half of the spectrum) 
        Pk(:,k) = P1;
    end
       
%     figure, plot(freq1, P1)

end

