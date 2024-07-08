% California Test Score Analysis .. Analysis for Chapter 14
% 7/17/2018
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

 
load([matdir model_label '_pc_scree']);
x = pc_scree(:,1);
variance_ratio = pc_scree(:,2);

n_plot = 50;  % number to plot
x = x(1:n_plot);
variance_ratio = variance_ratio(1:n_plot);

bar(x,variance_ratio)
