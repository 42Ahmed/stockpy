% Construct Figure 1.41
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
 lam = 1.3;
 bgrid = linspace(-1,2,ng)';
 y = [0;2.1];
 yg = repmat(y,1,ng)-repmat(bgrid',2,1);
 ssr = sum(yg.^2)';
 pen = lam*bgrid.^2;
 of = ssr+pen;
 plot(bgrid,ssr,'-','Linewidth',2,'color',rgb('blue'));
 hold on;
  plot(bgrid,pen,'-','Linewidth',2,'color',rgb('grey'));
  plot(bgrid,of,'- k','Linewidth',2);
 hold off;
 ax = gca;
 ax.YAxisLocation = 'origin';
 xlim([-1 2]);
 tmp=[bgrid ssr pen of];
 outfile_name = [outdir 'Figure_14_1.csv'];
 fileID = fopen(outfile_name,'w');
 prtmat_comma(tmp,fileID,'%8.4f','\n');
 
 