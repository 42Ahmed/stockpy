Stock and Watson's Introduction to Econometrics, 4th Edition

Chapter 17 DFM Replication Materials

The matlab script Factor_Data_1.m processes the data from Excel to an matlab matrix

Factor_estimation_4e.m computes the Scree plot in Figure 17.4 and the various statistics that help determine the number of factors.

Factor_estimation_4e_2.m computes the 4 factors used in Figure 17.5 and in the forecasting experiment summarized in Table 17.3.

(A note on the DFM analysis for the forecasting exeriment in Table 17.3:  As  you can see from the replication files, the experiment uses 4 factors estimated using the full sample of data.  Thus, the results do not represent a full pseudo-out-of-sample experiment:  this would require recursive estimation of the 4 factors.  As an exercise, you might to estimate the factors recursively and carry out a true pseudo-out-of sample experiment.)