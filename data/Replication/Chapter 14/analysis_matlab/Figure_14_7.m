% California Test Score Analysis .. Analysis for Chapter 14
% 9/16/2017
%
clear all;
small = 1.0e-10;
big = 1.0e+10;
this_date = datestr(now,'yyyymmdd');

% -----  File Directories -- overhead, etc.
 outdir = 'out/';
 figdir = 'fig/';
 matdir = 'mat/';

% ---- Label Associated with this run ---
 %model_label = 'small';  % label for model
 model_label = 'large';
 %model_label = 'verylarge';
 
% Cross-validation detail 
load([matdir model_label '_rmse_ridge']);
load([matdir model_label '_rmse_lasso_ssr_normalization']);
load([matdir model_label '_rmse_pc']);
pcn = rmse_pc(:,1);
rmse = rmse_pc(:,2);
plot(pcn,rmse,'LineWidth',3);
xlim([1 60]);
ylim([35 60]);
%set(gca,'XScale', 'log');

