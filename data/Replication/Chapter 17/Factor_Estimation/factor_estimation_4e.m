% Estimates factors, etc, TB chapter 17
% MWW, 20180326

% --- Preliminaries --- 
clear all;
small = 1.0e-10;
big = 1.0e+6;  

% --- File Name for output 
outfile_name = ['TB_Factor_1.out'];
fileID = fopen(outfile_name,'w');

load('datain');

% --- Parameters used for Esimation 
  % Calendar, sample, parameters
  est_par.smpl_par.nfirst = [1959 3];         % start date
  est_par.smpl_par.nlast  = [2017 4];         % end date
  est_par.smpl_par.calvec = datain.calvec;    % calendar 
  est_par.smpl_par.nper   = 4;                % number of periods per year

  % Factor analysis parameters
  est_par.fac_par.nt_min                  = 20;     % min number of obs for any series used to est factors
  est_par.fac_par.tol                     = 10^-8;  % precision of factor estimation (scaled by by n*t)
  
% VAR parameters for factors
est_par.var_par.nlag   = 4;    % number of lags


% Factor Parameters
nfac_max = 30;

% Extract Estimation Sample 
est_data = datain.bpdata(:,datain.bpinclcode==1);
est_namevec = datain.bpnamevec(datain.bpinclcode==1);


% --- Full Sample Results ---
% Compute Various Statistics for estimating the number of static and dynamic factors
nfac_out = est_nfac(est_data,nfac_max,est_par);

% Summarize and save results
% Static factors
kvec = (1:nfac_max)';
trace_r2 = ones(nfac_max,1)- nfac_out.st.ssr/nfac_out.st.tss;
marg_r2 = NaN*ones(nfac_max,1);
marg_r2(1) = trace_r2(1);
marg_r2(2:end) = trace_r2(2:end)-trace_r2(1:end-1);
ah_er = NaN(nfac_max,1);
ah_er(1:nfac_max-1) = marg_r2(1:nfac_max-1)./marg_r2(2:nfac_max);
fprintf(fileID,'Descriptive Statistics for determining the number of factors \n\n');
fprintf(fileID,'  Sample Period: %4i:Q%1i',est_par.smpl_par.nfirst);
fprintf(fileID,'-%4i:Q%1i\n',est_par.smpl_par.nlast);
fprintf(fileID,'  Static factor statistics\n');
fprintf(fileID,'    Nobs = %8i \n',nfac_out.st.nobs);
fprintf(fileID,'    Nbar = %5.2f \n',(nfac_out.st.nobs/nfac_out.st.nt));
fprintf(fileID,'K, trace R2, marginal r2, BN-ICP, AH-ER \n');
fprintf(fileID,'0,0,0,0\n');
for i = 1:nfac_max;
    fprintf(fileID,'%2i, ', kvec(i));
    fprintf(fileID,'%8.5f, ', trace_r2(i));
    fprintf(fileID,'%8.5f, ', marg_r2(i));
    fprintf(fileID,'%8.5f, ', nfac_out.st.bn(i));
    fprintf(fileID,'%8.5f \n', ah_er(i));
 end;
 
% -- Scree Plot --- 
scr = marg_r2;
x = 1:1:nfac_max;
bar(x,scr,0.5);
ax = gca;
ax.FontSize = 25;

set(gcf, 'Position', get(0, 'Screensize'));  % Full Screen
fig_str = ['ch17_scree']; 
str_fig = [fig_str]; 
saveas(gcf,[str_fig '.png']);

