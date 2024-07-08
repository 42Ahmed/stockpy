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
load([matdir model_label '_rmse_lasso']);
load([matdir model_label '_rmse_pc']);
lamhat = rmse_ridge(:,1);
rmse = rmse_ridge(:,2);
plot(lamhat,rmse);
set(gca,'XScale', 'log');


