% California Test Score Analysis 
% 7/13/2017
%
clear all;
small = 1.0e-10;
big = 1.0e+10;
this_date = datestr(now,'yyyymmdd');

% -----  File Directories -- overhead, etc.
 outdir = 'out/';
 figdir = 'fig/';
 matdir = 'mat/';

 model_label = 'large';
 
% ------------------- Variable Names;
load([matdir model_label '_var_names']);
load([matdir model_label '_xs']);

% Regression Coefficient on Raw variables, last is intercept
load([matdir model_label '_bols'],'bols');
load([matdir model_label '_bpc'],'bpc');
load([matdir model_label '_b_ridge'],'b_ridge');
load([matdir model_label '_b_lasso'],'b_lasso');

% Coefficients to Report
vlist = { ...
    'str_s' ...
    'med_income_z' ...
    'te_avgyr_s' ...
    'exp_1000_1999_d' ...
    'str_s_x_expoc_1000_1999_d' ...
    'str_s_x_ell_frac_s' ...
    'frpm_frac_s_x_te_tot_fte_rat_s' ...
    };

outfile_name = [outdir 'Table_14_4.asc'];
fileID = fopen(outfile_name,'w');
fprintf(fileID,'Results Reported in Table 14.4 \n');
fprintf(fileID,'Results for 817 predictor estimates \n');
fprintf(fileID,'Predictor, OLS, Ridge, Lasso, PC \n');
for i = 1:size(vlist,2);
  [~,colnum] = ismember(vlist(i),var_names);  
  str = char(var_names(colnum));
  fprintf(fileID,[str ',']);
  tmp = [bols(colnum) b_ridge(colnum) b_lasso(colnum) bpc(colnum)]*xs(colnum);
  prtmat_comma(tmp,fileID,'%8.2f','\n');
end;

model_label = 'small';
% ------------------- Variable Names;
load([matdir model_label '_var_names']);
load([matdir model_label '_xs']);

% Regression Coefficient on Raw variables, last is intercept
load([matdir model_label '_bols'],'bols');
load([matdir model_label '_bpc'],'bpc');
load([matdir model_label '_b_ridge'],'b_ridge');
load([matdir model_label '_b_lasso'],'b_lasso');

% Coefficients to Report
vlist = { ...
    'str_s' ...
    'med_income_z' ...
    'te_avgyr_s' ...
    'exp_1000_1999_d' ...
    };

fprintf(fileID,'\n\n Results for 4 predictor estimates \n');
fprintf(fileID,'Predictor, OLS\n');
for i = 1:size(vlist,2);
  [~,colnum] = ismember(vlist(i),var_names);  
  str = char(var_names(colnum));
  fprintf(fileID,[str ',']);
  tmp = [bols(colnum)]*xs(colnum);
  prtmat_comma(tmp,fileID,'%8.2f','\n');
end;



