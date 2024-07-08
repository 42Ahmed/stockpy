% Read in File from Excel
W1 = dlmread('Wilshire.asc');
ii = W1(:,2) == 999;
W2 = W1(ii==0,:);
ex_date = W2(:,1);  % Excel date .. serial number
w_index = W2(:,2);  % Wilshire Index
% Convert to Matlab serial date
m_date = ex_date + 693960;  %(Excel 2011 is first date is 1/1/1900, Matlab is 1/1/0000, 693960 is difference)
dec_date = date_ser2dec(m_date);
n = size(dec_date,1);
w_return = NaN(n,1);
w_return(2:end) = 100*log(w_index(2:end)./w_index(1:end-1));

% Compute Realized Volatility
T = size(w_return,1);
rvse = NaN(T,1);
h = 20;
for t = h:T;
    rvse(t) = sqrt(mean(w_return(t-h+1:t).^2));
end;
plot(dec_date,w_return,'- b');
hold on;
 plot(dec_date,rvse,'- r','LineWidth',3);
 plot(dec_date,-rvse,'- r','LineWidth',3);
hold off;
ylim([-10 12.5]);
ax = gca;
ax.FontSize = 25;
ylabel('Percent per day');


% Save Data on Returns

% --- File Name for output 
outfile_name = ['Figure_17_3_returns_and_RVBands.asc'];
fileID = fopen(outfile_name,'w');
prtmat_comma([dec_date w_return rvse -rvse],fileID,'%10.5f','\n');
