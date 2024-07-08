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
plot(dec_date,w_return,'- b');
ylim([-10 12.5]);
ax = gca;
ax.FontSize = 25;
ylabel('Percent per day');
title('(d) Percentage Change in Daily Values of the Wilshire 5000 Stock Price Index');
set(gcf, 'Position', get(0, 'Screensize'));  % Full Screen
fig_str = ['Figure_15_2_d']; str_fig = [fig_str]; saveas(gcf,[str_fig '.png']);

% Save Data on Returns

% --- File Name for output 
outfile_name = ['Wilshire_returns.csv'];
fileID = fopen(outfile_name,'w');
prtmat_comma([dec_date(2:end) w_return(2:end)],fileID,'%10.5f','\n');
	
outfile_name = ['Wilshire_returns.asc'];
fileID = fopen(outfile_name,'w');
prtmat_comma([w_return(2:end)],fileID,'%10.5f','\n');

