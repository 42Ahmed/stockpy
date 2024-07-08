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
 ny = 3;
 lam = 2.7;
 bgrid = linspace(-1,2,ng)';
 y = [0;2.4;0.5]+[-1;0;1];
 yg = repmat(y,1,ng)-repmat(bgrid',ny,1);
 ssr = sum(yg.^2)';
 pen = lam*abs(bgrid);
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
 outfile_name = [outdir 'Figure_14_3a.csv'];
 fileID = fopen(outfile_name,'w');
 prtmat_comma(tmp,fileID,'%8.4f','\n');
% error('tmp');
 
 y = [0;0.8;0.4]+[-1;0;1];
 yg = repmat(y,1,ng)-repmat(bgrid',ny,1);
 ssr = sum(yg.^2)';
 pen = lam*abs(bgrid);
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
 outfile_name = [outdir 'Figure_14_3b.csv'];
 fileID = fopen(outfile_name,'w');
 prtmat_comma(tmp,fileID,'%8.4f','\n');
 
 