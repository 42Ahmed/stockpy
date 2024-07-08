% Estimates factors, etc, TB chapter 17
% MWW, 20180326

% --- Preliminaries --- 
clear all;
small = 1.0e-10;
big = 1.0e+6;  

load('datain');

n_series = size(datain.bpdata,2);
% All Parameters 
nfactors = 4;
fac_est_first = [1959 3];     % First period for factor + lambda estimation
fac_est_last = [2017 4];      
    
  
  % Parameters for factor estimation program
  nfac.unobserved = nfactors;
  nfac.observed = 0;
  nfac.total = nfac.unobserved+nfac.observed;
  est_par.fac_par.nfac = nfac;
  est_par.fac_par.w = 1;                           % This contains data on the observed factors (scalar if none)
  est_par.smpl_par.nfirst = fac_est_first;         % start date
  est_par.smpl_par.nlast  = fac_est_last;    % end date for VAR and univariate AR 
  est_par.smpl_par.calvec = datain.calvec;         % calendar
  est_par.smpl_par.nper   = 4;                     % number of periods a year  
  est_par.fac_par.nt_min                  = 20;     % min number of obs for any series used to est factors
  est_par.lambda.nt_min                   = 40;     % min number of obs for any series used to estimate lamba, irfs, etc.
  est_par.fac_par.tol                     = 10^-10;  % precision of factor estimation (scaled by by n*t)  
  est_par.fac_par.lambda_constraints_est  = 1;  % no constraints on lambda
  est_par.fac_par.lambda_constraints_full = 1;  % no constraints on lambda

  
  


% Estimate Factors and Lambda
  est_data = datain.bpdata(:,datain.bpinclcode==1);
  lsout = factor_estimation_ls(est_data, est_par);
  factor_estimate = lsout.fac;
  
  % Save Factors in Matlab Format for full sample
  % Calendars for problem
  nfirst = datain.calds(1,:);
  nlast = datain.calds(end,:);
  [dnobs,calvec,calds] = calendar_make(nfirst,nlast,4);  
  % -- Convert factor estimates to this calendar
  factor_all = NaN(dnobs,nfactors);
  ismpl = smpl(calvec,nfirst,nlast,4);
  factor_all(ismpl==1,:) = factor_estimate;    % Insample estimates of factors
  str_tmp = ['factor_all_' num2str(nfactors)];
  save(str_tmp,'factor_all'); 
  
  % Write Factors as ASCII files
  outfile_name = ['factor_4.asc'];
  fileID = fopen(outfile_name,'w');
  for t = 3:dnobs;
      fprintf(fileID,'%5.3f %5.3f %5.3f %5.3f \n',factor_all(t,:));
  end;
