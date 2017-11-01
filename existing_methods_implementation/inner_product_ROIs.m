function ip = inner_product_ROIs(Sj, N)   
% inner product between each ROI's signals

% measure the cos angle between 2 signals
ip = [];
for i = 1:N;
   for j = i:N;
        if i == j
            continue
        else 
        
           s_i = Sj(:,i);
           s_j = Sj(:,j);

           % normalize the signals: subtract the mean and divide by std
           s_i = (s_i - mean(s_i)) / std(s_i);
           s_j = (s_j - mean(s_j)) / std(s_j);

           ip_ij = dot((s_i/norm(s_i,2)), (s_j/norm(s_j,2)));
           ip = [ip ip_ij]; % vector

         end
   end
end
end