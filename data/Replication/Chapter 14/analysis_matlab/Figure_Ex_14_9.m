% Construct Figure for Exercise 14.9
%
clear all;
small = 1.0e-10;
big = 1.0e+10;
this_date = datestr(now,'yyyymmdd');

% -----  File Directories -- overhead, etc.
 outdir = 'out/';
 figdir = 'fig/';
 matdir = 'mat/';

 ng = 91;
 lam = 1;
 bgrid = linspace(-2,5,ng)';
 y = 2;
 x = 1;
 yg = y - x*bgrid;
 ssr = yg.^2;
 pen = lam*bgrid.^2;
 of = ssr+pen;
 plot(bgrid,ssr,'-','Linewidth',2,'color',rgb('blue'));
 hold on;
  plot(bgrid,pen,'-','Linewidth',2,'color',rgb('grey'));
  plot(bgrid,of,'- k','Linewidth',2);
 hold off;
 legend('SSR','Ridge Penalty','Ridge Penalized SSR = SSR + Ridge Penalty');
 ax = gca;
 ax.YAxisLocation = 'origin';
 xlim([-2 5]);
 
 
 