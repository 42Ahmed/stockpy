function [xdata_insample,xdata_oos,var_names] =   variable_setup_verylarge(varname,varvalue_insample,varvalue_oos);
% Small Model list of variables

% List some variables
var_names_list = { ... 
'str_s' ...
'te_avgyr_s' ...
'exp_1000_1999_d' ...
'med_income_z' ...
'frpm_frac_s' ...
'ell_frac_s' ...
'freem_frac_s' ...
'enrollment_s' ...
'fep_frac_s' ...
'edi_s' ...
're_aian_frac_s' ...
're_asian_frac_s' ...
're_baa_frac_s' ...
're_fil_frac_s' ...
're_hl_frac_s' ...
're_hpi_frac_s' ...
're_tom_frac_s' ...
're_nr_frac_s' ...
'te_fte_s' ...
'te_1yr_frac_s' ...
'te_2yr_frac_s' ...
'te_tot_fte_rat_s' ...
'exp_2000_2999_d' ...
'exp_3000_3999_d' ...
'exp_4000_4999_d' ...
'exp_5000_5999_d' ...
'exp_6000_6999_d' ...
'exp_7000_7999_d' ...
'exp_8000_8999_d' ...
'expoc_1000_1999_d' ...
'expoc_2000_2999_d' ...
'expoc_3000_3999_d' ...
'expoc_4000_4999_d' ...
'expoc_5000_5999_d' ...
'revoc_8010_8099_d' ...
'revoc_8100_8299_d' ...
'revoc_8300_8599_d' ...
'revoc_8600_8799_d' ...
'age_frac_5_17_z' ...
'age_frac_18_24_z' ...
'age_frac_25_34_z' ...
'age_frac_35_44_z' ...
'age_frac_45_54_z' ...
'age_frac_55_64_z' ...
'age_frac_65_74_z' ...
'age_frac_75_older_z' ...
'pop_1_older_z' ...
'sex_frac_male_z' ...
'ms_frac_now_married_z' ...
'ms_frac_now_divorced_z' ...
'ms_frac_now_widowed_z' ...
'ed_frac_hs_z' ...
'ed_frac_sc_z' ...
'ed_frac_ba_z' ...
'ed_frac_grd_z' ...
'hs_frac_own_z' ...s
'moved_frac_samecounty_z' ...
'moved_frac_difcounty_z' ...
'moved_frac_difstate_z' ...
'moved_frac_abroad_z' ...
}';

% Levels
var_names = var_names_list;
% Levels data
  xdata_insample = getvar(var_names(1),varname,varvalue_insample);
  xdata_oos = getvar(var_names(1),varname,varvalue_oos);
  for i = 2:size(var_names,1);
      x = getvar(var_names(i),varname,varvalue_insample);
      xdata_insample = [xdata_insample x];
      x = getvar(var_names(i),varname,varvalue_oos);
      xdata_oos = [xdata_oos x];
  end;

 % Some interactions
  var1 = var_names_list;
  var2 = var_names_list;
  nn = size(var_names,1);
  for i = 1: size(var1,1);
      x1_insample = getvar(var1(i),varname,varvalue_insample);
      x1_oos = getvar(var1(i),varname,varvalue_oos);
      x1str = char(var1(i));
      for j = i:size(var2,1);    % note this starts at i 
        x2_insample = getvar(var2(j),varname,varvalue_insample);
        x = x1_insample.*x2_insample;
        xdata_insample = [xdata_insample x];
        
        x2_oos = getvar(var2(j),varname,varvalue_oos);
        x = x1_oos.*x2_oos;
        xdata_oos = [xdata_oos x];
           
        x2str = char(var2(j));
        tmp_str = [x1str '_x_' x2str];
        nn = nn+1;
        var_names{nn,1} = tmp_str;
      end;
  end;
  
  % cubes
  var1 = var_names_list;
  nn = size(var_names,1);
  for i = 1: size(var1,1);
      x1 = getvar(var1(i),varname,varvalue_insample);
      x = x1.*x1.*x1;
      xdata_insample = [xdata_insample x];
      
      x1 = getvar(var1(i),varname,varvalue_oos);
      x = x1.*x1.*x1;
      xdata_oos = [xdata_oos x];
      
      x1str = char(var1(i));
      tmp_str = [x1str '_cubed'];
      nn = nn+1;
      var_names{nn,1} = tmp_str;
  end;
 
binary_var_names = {
'charter_s' ...
'yrcal_s' ...
'unified_d' ...
'la_unified_d' ...
'sd_unified_d' ...
}';  

% Add Binary Variables
var1 = binary_var_names;
nn = size(var_names,1);

for i = 1: size(var1,1);
  x = getvar(var_names(i),varname,varvalue_insample);
  xdata_insample = [xdata_insample x];
  x = getvar(var_names(i),varname,varvalue_oos);
  xdata_oos = [xdata_oos x];
  x1str = char(var1(i));
  tmp_str = [x1str];
  nn = nn+1;
  var_names{nn,1} = tmp_str;
end;

school_var_names = { ...
'str_s' ...
'te_avgyr_s' ...
'exp_1000_1999_d' ...
'frpm_frac_s' ...
'ell_frac_s' ...
'freem_frac_s' ...
'enrollment_s' ...
'fep_frac_s' ...
'edi_s' ...
're_aian_frac_s' ...
're_asian_frac_s' ...
're_baa_frac_s' ...
're_fil_frac_s' ...
're_hl_frac_s' ...
're_hpi_frac_s' ...
're_tom_frac_s' ...
're_nr_frac_s' ...
'te_fte_s' ...
'te_1yr_frac_s' ...
'te_2yr_frac_s' ...
'te_tot_fte_rat_s' ...
}';

% Add interactions of school variables with binary indicators
  var1 = binary_var_names;
  var2 = school_var_names;
  nn = size(var_names,1);
  for i = 1: size(var1,1);
      x1_insample = getvar(var1(i),varname,varvalue_insample);
      x1_oos = getvar(var1(i),varname,varvalue_oos);
      x1str = char(var1(i));
      for j = 1:size(var2,1);    % note this starts at 1 
        x2_insample = getvar(var2(j),varname,varvalue_insample);
        x = x1_insample.*x2_insample;
        xdata_insample = [xdata_insample x];
        
        x2_oos = getvar(var2(j),varname,varvalue_oos);
        x = x1_oos.*x2_oos;
        xdata_oos = [xdata_oos x];
           
        x2str = char(var2(j));
        tmp_str = [x1str '_x_' x2str];
        nn = nn+1;
        var_names{nn,1} = tmp_str;      
      end;
  end;
   
end
