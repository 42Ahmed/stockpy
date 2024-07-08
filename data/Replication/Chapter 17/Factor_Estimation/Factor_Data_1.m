% Factor_Data_1.m
% Read in Data for TB factor
% Carry out transformations, aggregate to quarterly and save results for future use

small = 1.0e-10;
big = 1.0e+6;  

% -- Parameters for Outlier Adjustment -- ;
% -- See the utility adjout.m for the definition of these parameters
i_demean = 0;
ioutlier=1;     % = 1 for correcting outliers in X ;
io_method=4;    % Replacement of outliers
thr1=4.5;       % Threshold multiple for IQR ;
thr2=3;         % Threshold multiple for IQR ;

% Calendars
[dnobs_m,calvec_m,calds_m] = calendar_make([1959 1],[2017 12],12);
[dnobs_q,calvec_q,calds_q] = calendar_make([1959 1],[2017 4],4);

% --------------- Read In Monthly Data ---------------- ;
xlsname = 'Factor_Data_Fred.xlsx';
% Read Data 
miss_code = 1.0e+32;   % missing value code for entries in Excel Fle;
ns_m = 26*3+14-1;      % number of series 
ndesc=2;               % number of "description" rows in Excel file
ncodes=6;              % number of rows of "codes" in Excel file
sheet='Monthly';
[namevec,descmat,tcodemat,datevec,datamat_m] = readxls(xlsname,sheet,ns_m,dnobs_m,ndesc,ncodes);
labvec_long=descmat(:,1);    % Vector of "long" labels 
labvec_short=descmat(:,2);   % Vector of "short" labels
aggcode=tcodemat(1,:)';       % Temporal aggregation code
tcode=tcodemat(2,:)';         % transformation code
defcode=tcodemat(3,:)';       % code for price deflation (nominal to real)
outliercode=tcodemat(4,:)';   % code for outlier adjustment
includecode=tcodemat(5,:)';   % code for use in factor estimation
catcode=tcodemat(6,:)';       % category code for ordering variables

% Convert Namestrings to upper case 
namevec = upper(namevec);
% Eliminate any leading or trailing blanks 
namevec=strtrim(namevec);

% Replace missing values with NaN
isel = datamat_m == miss_code;
datamat_m(isel) = NaN;

% Price Deflators
str='PCEPI';    %PCE Price Deflator 
str=upper(str);
j = colnumber(str,namevec);
price_def = datamat_m(:,j);
str='PCEPILFE';    % PCE-xFE Price Deflator 
str=upper(str);
j = colnumber(str,namevec);
price_def_lfe = datamat_m(:,j); 

% Form Some new Variables
% Interest Rate Spreads .. relative to 3 month TBill Rate
str='TB3MS';    % 3 month tbill rate 
str=upper(str);
j = colnumber(str,namevec);
base = datamat_m(:,j);
str_base = str;

strvec = {
    'AAA' ...
    'BAA' ...
    'FEDFUNDS' ...
    'DCPF3M' ...
    'GS1' ... 
    'GS10' ...
    'MORTGAGE30US' ...
    'TB6MS'
    }';
for ii = 1:size(strvec,1);
    str = char(strvec(ii));
    str=upper(str);  
    j = colnumber(str,namevec);
    x = datamat_m(:,j);
    y = x-base;
    datamat_m = [datamat_m y];
    nstr = [str '_' str_base];
    l1str = ['Spread: ' nstr];
    l2str = nstr;
    namevec = [namevec;cellstr(nstr)];
    labvec_long = [labvec_long;cellstr(l1str)];
    labvec_short = [labvec_short;cellstr(l2str)];
    defcode = [defcode;0];
    aggcode = [aggcode;0];
    tcode = [tcode;1];
    outliercode = [outliercode;0];
    includecode = [includecode;1];
    catcode = [catcode;catcode(j)+.001];
end;

% Form Panel Data set of transformed Data 
bpdata=0; 
for is = 1:size(namevec,1);  
  if includecode(is) ~= 0;          % Ignore series if includecode == 0
      x = datamat_m(:,is);
      if defcode(is) == 1;
          x = x./price_def;
          tmp = char(labvec_long(is));
          tmp = [tmp ' Defl by PCE Def'];
          labvec_long(is) = cellstr(tmp);
          tmp = char(labvec_short(is));
          tmp =['Real_' tmp];
          labvec_short(is) = cellstr(tmp);
      end;
      if defcode(is) == 2;
          x = x./price_def_lfe;
          tmp = char(labvec_long(is));
          tmp = [tmp ' Defl by PCE(LFE) Def'];
          labvec_long(is) = cellstr(tmp);
          tmp = char(labvec_short(is));
          tmp =['Real_' tmp];
          labvec_short(is) = cellstr(tmp);
      end;  
      xq=mtoq(x,calds_m,calds_q,aggcode(is));  % Temporally aggregated to quarterly
      y=transx(xq,tcode(is));                  % Transform .. log, first difference, etc.
      
      y_noa=y;                  % Save value of y before adjustment for outliers 
      if ioutlier==1           % Global flag to turn outlier adjustment on and off;
        if outliercode(is)==1;
          % -- Check For Outliers  -- ;
          ya=adjout(y,thr1,io_method);             % 4 = 1 sided median replacement ;
          if size(ya,1)==1; error('Error in outlier adjustment'); end;
          y=ya;
        end;
        if outliercode(is)==2;
          % -- Check For Outliers  -- ;
          ya=adjout(y,thr2,io_method);             % 4 = 1 sided median replacement ;
          if size(ya,1)==1; error('Error in outlier adjustment'); end;
          y=ya;
        end;
      end
        
      % Save series, etc.
      % First time through 
      if size(bpdata,1)==1;
        bpdata_raw=xq;
        bpdata=y;
        bpdata_noa=y_noa;
        bpnamevec=namevec(is);
        bplabvec_long=labvec_long(is);
        bplabvec_short=labvec_short(is);
        bptcodevec=tcode(is);
        bpoutliervec=outliercode(is);
        bpcatcode=catcode(is);
        bpinclcode=includecode(is);
      else;
      % Not first time through
        bpdata_raw=[bpdata_raw xq];
        bpdata=[bpdata y];
        bpdata_noa=[bpdata_noa y_noa];
        bpnamevec=[bpnamevec;namevec(is)];
        bplabvec_long=[bplabvec_long;labvec_long(is)];
        bplabvec_short=[bplabvec_short;labvec_short(is)];
        bptcodevec= [bptcodevec ; tcode(is)];
        bpoutliervec=[bpoutliervec ; outliercode(is)];  
        bpcatcode=[bpcatcode ; catcode(is)];
        bpinclcode=[bpinclcode ; includecode(is)];
      end;
    end;
end;

% -------------------- Do the same for Quarterly Data -----------------
% Read Data 
miss_code = 1.0e+32;
ns_q = 2*26+3-1;
ndesc=2;
ncodes=5;
sheet='Quarterly';
[namevec,descmat,tcodemat,datevec,datamat] = readxls(xlsname,sheet,ns_q,dnobs_q,ndesc,ncodes);
labvec_long=descmat(:,1);
labvec_short=descmat(:,2);
tcode=tcodemat(1,:)';
defcode=tcodemat(2,:)';
outliercode=tcodemat(3,:)';
includecode=tcodemat(4,:)';
catcode=tcodemat(5,:)';

% Convert Namestrings to upper case 
namevec = upper(namevec);
% Eliminate any leading or trailing blanks 
namevec=strtrim(namevec);
% Replace missing values with NaN
isel = datamat == miss_code;
datamat_m(isel) = NaN;

%Deflators
str='PCECTPI';    % PCE Deflator
str=upper(str);
j = colnumber(str,namevec);
price_def = datamat(:,j);
str='JCXFE';    % PCE Excl. food and energy
str=upper(str);
j = colnumber(str,namevec);
price_def_lfe = datamat(:,j);  
str='GDPCTPI';    % GDP Deflator
str=upper(str);
j = colnumber(str,namevec);
price_def_pgdp = datamat(:,j);  

% Constructed Data series
% Change in inventories to GDP 
str='GDPC1';    % 3 month tbill rate 
str=upper(str);
j = colnumber(str,namevec);
gdp = datamat(:,j);
str='CBIC1';    % 3 month tbill rate 
str=upper(str);
j = colnumber(str,namevec);
d_inv = datamat(:,j);
y = d_inv./gdp;
datamat = [datamat y];
nstr = ['CBIC1_GDP'];
l1str = ['Ch. Inv/GDP'];
l2str = ['Ch. Inv/GDP'];
namevec = [namevec;cellstr(nstr)];
labvec_long = [labvec_long;cellstr(l1str)];
labvec_short = [labvec_short;cellstr(l2str)];
defcode = [defcode;0];
tcode = [tcode;1];
outliercode = [outliercode;0];
includecode = [includecode;1];
catcode = [catcode;catcode(j)+.001];

% Flow of Funds data 
str='TNWBSHNO_sa';    % Real Estate assets in Millionas 
str=upper(str);
j = colnumber(str,namevec);
x = datamat(:,j);
x = x/1000;  % Billions
str='HNOREMQ027S_sa';    % Total NonFinancial Assets 
str=upper(str);
j = colnumber(str,namevec);
z = datamat(:,j);
y = z-x;
datamat = [datamat y];
nstr = ['HHW:TA_NonFin_XRE'];
l1str = ['HHW:Total NonFinanicial Assets less Real Estate'];
l2str = ['HHW:TA_NonFin_XRE'];
namevec = [namevec;cellstr(nstr)];
labvec_long = [labvec_long;cellstr(l1str)];
labvec_short = [labvec_short;cellstr(l2str)];
defcode = [defcode;2];
tcode = [tcode;5];
outliercode = [outliercode;0];
includecode = [includecode;1];
catcode = [catcode;catcode(j)+.001];

% Form Panel Data set of transformed Data
for is = 1:size(namevec,1); 
  if includecode(is) ~= 0;
      x = datamat(:,is);
      if defcode(is) == 1;
          x = x./price_def;
          tmp = char(labvec_long(is));
          tmp = [tmp ' Defl by PCE Def'];
          labvec_long(is) = cellstr(tmp);
          tmp = char(labvec_short(is));
          tmp =['Real_' tmp];
          labvec_short(is) = cellstr(tmp);
      end;
      if defcode(is) == 2;
          x = x./price_def_lfe;
          tmp = char(labvec_long(is));
          tmp = [tmp ' Defl by PCE(LFE) Def'];
          labvec_long(is) = cellstr(tmp);
          tmp = char(labvec_short(is));
          tmp =['Real_' tmp];
          labvec_short(is) = cellstr(tmp);
      end;
      if defcode(is) == 3;
          x = x./price_def_pgdp;
          tmp = char(labvec_long(is));
          tmp = [tmp ' Defl by GDP Def'];
          labvec_long(is) = cellstr(tmp);
          tmp = char(labvec_short(is));
          tmp =['Real_' tmp];
          labvec_short(is) = cellstr(tmp);
      end;     
      
      y=transx(x,tcode(is));
      
      y_noa=y;
      if ioutlier==1;           % Global flag to turn outlier adjustment on and off;
        if outliercode(is)==1;
          % -- Check For Outliers  -- ;
          ya=adjout(y,thr1,io_method);             % 4 = 1 sided median replacement ;
          if size(ya,1)==1; error('Error in outlier adjustment'); end;
          y=ya;
        end;
        if outliercode(is)==2;
          % -- Check For Outliers  -- ;
          ya=adjout(y,thr2,io_method);             % 4 = 1 sided median replacement ;
          if size(ya,1)==1; error('Error in outlier adjustment'); end;
          y=ya;
        end;
      end;    
      bpdata_raw=[bpdata_raw x];
      bpdata=[bpdata y];
      bpdata_noa=[bpdata_noa y_noa];
      bpnamevec=[bpnamevec;namevec(is)];
      bplabvec_long=[bplabvec_long;labvec_long(is)];
      bplabvec_short=[bplabvec_short;labvec_short(is)];
      bptcodevec= [bptcodevec ; tcode(is)];
      bpoutliervec=[bpoutliervec ; outliercode(is)];  
      bpcatcode=[bpcatcode ; catcode(is)];
      bpinclcode=[bpinclcode ; includecode(is)];        
   end;
end;

%{
% Plot variables that are included
for is = 1: size(bpnamevec,1);
    str = [num2str(is) ': ' char(bpnamevec(is))];
    figure;
    subplot(1,2,1);
    plot(calvec_q,bpdata_raw(:,is));
    xlim([1955 2020]);
    title(str);
    str = [num2str(is) ': ' char(bplabvec_short(is))];
    subplot(1,2,2);
    plot(calvec_q,bpdata(:,is));
    xlim([1955 2020]);
    title(str);
    set(gcf, 'Position', get(0, 'Screensize'));  % Full Screen
    waitforbuttonpress; 
    close(gcf);
end;
%}

% Save quarterly calendar variables discarding "_q" suffix
calvec=calvec_q;
calds=calds_q;
dnobs=size(calvec,1);

% Reorganize Series so they are in correct order given by Catcode
[tmp,isort] = sort(bpcatcode);
bpdata_raw=bpdata_raw(:,isort);
bpdata=bpdata(:,isort);
bpdata_noa=bpdata_noa(:,isort);
bpnamevec=bpnamevec(isort);
bplabvec_long=bplabvec_long(isort);
bplabvec_short=bplabvec_short(isort);
bptcodevec =  bptcodevec(isort);
bpoutliervec = bpoutliervec(isort);
bpcatcode = bpcatcode(isort);
bpinclcode=bpinclcode(isort);

% Save Variable Series 
datain.bpdata_raw = bpdata_raw;
datain.bpdata = bpdata;
datain.bpdata_noa = bpdata_noa;
datain.bpnamevec = bpnamevec;
datain.bplabvec_long = bplabvec_long;
datain.bplabvec_short = bplabvec_short;
datain.bpoutliervec = bpoutliervec;
datain.bptcodevec = bptcodevec;
datain.bpcatcode = bpcatcode; 
datain.bpinclcode = bpinclcode;
datain.calvec = calvec;
datain.calds = calds;
datain.dnobs = dnobs;
str_tmp = ['datain'];
save(str_tmp,'datain'); 


% ------------- Summary 
% List Series in Each Category
cat1 = 'NIPA';
cat2 = 'Industrial Production';
cat3 = 'Employment and Unemployment';
cat5 = 'Orders, Inventories, and Sales';
cat4 = 'Housing Starts and Permits';
cat6 = 'Prices';
cat7 = 'Productivity and Earnings';
cat8 = 'Interest Rates';
cat9 = 'Money and Credit';
cat12 = 'International Variables';
cat10 = 'Asset Prices, Wealth, and Household Balance Sheets';
cat14 = 'Other';
cat20 = 'Oil Market Variables';

% reorder
reordervec = [1 2 3 5 4 6 7 8 9 12 10 14 20];
catvec = {cat1 cat2 cat3 cat5 cat4 cat6 cat7 cat8 cat9 cat12 cat10 cat14 cat20};

outfile_name = ['Table_DataDescriptionSummary.out'];
fileID = fopen(outfile_name,'w');
fprintf(fileID,' ~Category~Number of series used for factor estimation \n'); 
for i = 1:size(reordervec,2);
    fprintf(fileID,'(%-2i)~',i);
    tmp =char(catvec(i));
    fprintf(fileID,[tmp '~']);
    icat = reordervec(i);
    ii = floor(bpcatcode) == icat;
    nii = sum(ii);  % Number of Series in This Category;
    fprintf(fileID,'%-3i \n',nii);
end;
fprintf(fileID,'~~~\n');
fprintf(fileID,'~Total~');
nii = size(bpinclcode,1);
fprintf(fileID,'%-3i \n',nii);

outfile_name = ['Table_DataDescriptionDetailed.out'];
fileID = fopen(outfile_name,'w');
fprintf(fileID,'~Name~Description~Smpl~Trans~Outlier~FacEst \n'); 
inumber = 0;
for i = 1:size(reordervec,2);
    tmp =char(catvec(i));
    fprintf(fileID,['~~' tmp '~~~ \n']);
    icat = reordervec(i);
    ii = floor(bpcatcode) == icat;
    tmp_bplabvec_short = bplabvec_short(ii==1);
    tmp_bplabvec_long = bplabvec_long(ii==1);
    tmp_bptcodevec=bptcodevec(ii==1);
    tmp_bpoutliervec=bpoutliervec(ii==1);
    tmp_bpinclcode = bpinclcode(ii==1);
    tmp_bpdata_raw = bpdata_raw(:,ii==1);
    for ij = 1:sum(ii);
        inumber = inumber+1;
        fprintf(fileID,'%-3i~',inumber);
        tmp = char(tmp_bplabvec_short(ij));
        fprintf(fileID,[tmp '~']);
        tmp = char(tmp_bplabvec_long(ij));
        fprintf(fileID,[tmp '~']);
        tmp = tmp_bpdata_raw(:,ij);
        tmp = calds(isnan(tmp)==0,:);
        fprintf(fileID,'%4i:Q%1i-%4i:Q%1i~',[tmp(1,:) tmp(end,:)]);
        fprintf(fileID,'%1i~',tmp_bptcodevec(ij));
        fprintf(fileID,'%1i~',tmp_bpoutliervec(ij));
        fprintf(fileID,'%1i \n',(tmp_bpinclcode(ij)==1));
    end;
end;

% Tabulate number of series available over complete sample period
ii = 0;
for i = 1:size(bpdata_raw,2);
    y = bpdata_raw(:,i);
    if sum(isnan(y)) == 0;
        ii = ii+1;
    end;
end;
fprintf('Number of series without missing values: %3i \n',ii);
