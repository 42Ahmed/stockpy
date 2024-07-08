function [xdata_insample,xdata_oos,var_names] = variable_setup(model_label,varname,varvalue_insample,varvalue_oos);
%   Getvariables for different models
%   
if strcmp(model_label,'small') == 1;
  [xdata_insample,xdata_oos,var_names] =   variable_setup_small(varname,varvalue_insample,varvalue_oos);
end;
    
if strcmp(model_label,'large') == 1;
  [xdata_insample,xdata_oos,var_names] =   variable_setup_large(varname,varvalue_insample,varvalue_oos); 
end;
    
if strcmp(model_label,'verylarge') == 1;
 [xdata_insample,xdata_oos,var_names] =   variable_setup_verylarge(varname,varvalue_insample,varvalue_oos);    
end;

end

