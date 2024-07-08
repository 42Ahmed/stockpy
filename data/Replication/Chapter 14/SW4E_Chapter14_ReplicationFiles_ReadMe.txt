Stock and Watson's Introduction to Econometrics, 4th Edition

Chapter 14 Replication Materials

Data:  All data are in the data subdirectory
The list of variables can be found in CASchools_VariableList_Chapter14_SW4E.pdf

Replication files can be found in the analysis_matlab files.

Note: Calculations for this chapter were carried out using MATLAB (2017b)
Run the following Matlab scripts:

(1) caschools_insample_outofsample_datasets.m
    This program randomly divides the complete dataset into "in-sample" and 'out-of-sample' datasets.
    
(2) caschools_ch14_analysis.m:  This program computes the OLS, Ridge, Lasso, and PC estimates.  You need to run this three times for each of the values of "model_label" given around lines 30-32. (The labels are the the 'small (k=4)', 'large (k = 817)', and 'very large (k = 2065)' models.)
Output from these programs can be found in the 'out' subdirectory.  This output is used for Table 14.3

(3) Matlab scripts are provided to produce the figures and other tables:
Figure_14_1.m  (This uses hyptothetical data, n=3 and estimates a mean)
Figure_14_2.m
Figure_14_3_a_b.m  (This uses hyptothetical data, n=3 and estimates a mean)
Figure_14_4.m
Figure_14_6.m
Figure_14_7.m
Figure_14_8.m
Table_4_4.m
