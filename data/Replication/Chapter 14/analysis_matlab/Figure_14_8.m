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
 
load([matdir model_label '_ydata_oos']);
load([matdir model_label '_ypredict_ols']);
load([matdir model_label '_ypredict_pc']);
load([matdir model_label '_ypredict_ridge']);
load([matdir model_label '_ypredict_lasso']);

ms = 1.8;
figure;
subplot(2,2,1);
plot(ypredict_ols,ydata_oos,'bo','MarkerFaceColor','b','MarkerSize',ms);
xlim([550 1000]);
ylim([550 1000]);

subplot(2,2,2);
plot(ypredict_ridge,ydata_oos,'bo','MarkerFaceColor','b','MarkerSize',ms);
xlim([550 1000]);
ylim([550 1000]);

subplot(2,2,3);
plot(ypredict_ridge,ypredict_lasso,'bo','MarkerFaceColor','b','MarkerSize',ms);
xlim([550 1000]);
ylim([550 1000]);

subplot(2,2,4);
plot(ypredict_ridge,ypredict_pc,'bo','MarkerFaceColor','b','MarkerSize',ms);
xlim([550 1000]);
ylim([550 1000]);

