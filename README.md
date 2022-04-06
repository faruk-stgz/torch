# Readme:

This depo contains 3 queries and results that were captured after running those queries. 
The data source is accessible at https://beta.healthdata.gov/api/views/j8mb-icvb/rows.csv?accessType=DOWNLOAD
The Data dictionary is accesible at: https://beta.healthdata.gov/dataset/COVID-19-Diagnostic-Laboratory-Testing-PCR-Testing/j8mb-icvb

1) The total number of PCR tests performed as of yesterday in the United States.
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1 
  
  
SumOfAllResults
581306305


This query first finds the most recent date we have the data for, that isn't today. After that it is a simple summing operation 
to capture the total number of test results reported at that particular date. It is made easier because this value is already dynamic 
value, it is only partitioned by date, state and outcome of the test. So just summing all the results as of yesterday throughout the US 
gives us the information we need.


2) The 10 states with the highest test positivity rate (positive tests / tests performed) for tests performed in the last 30 days.
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1 
  
This query captures the top 10 states with the highest test positivity rate for the tests performed in the last 30 days. 
We will use sum of all Positive values from new_results_reported column and divide it by sum of all values from new_results_reported column 
to get the number of positive cases. We will use only dates starting with the date 30 days ago. 
This is easier than calculating what the status was on day 30 and finding the difference between that number
and number of cases yesterday if we were to use the same column as in the first query. 
However if you dig deeper and compare these numbers these 2 columns don't match. This is something that should be explored more.
For example: 

Status on 6th of March in Texas:	
Inconclusive	165944	
Negative	41559349	
Positive	6762201	
Total: 48487494

Status on 1st of April in Texas: 
Inconclusive	168803
Negative	42516397
Positive	6785957
Total: 49471157

Difference between those 2 totals should give us the number of tests that were completed during this time: 983663
and in theory this number should be equal to the number that is a sum of new results from March 6th to April 1st but it does not do that - 
sum of new results is 1010385 and we can see that there is 26772 that is difference between those 2 numbers. I decided to use this column 
because it is not a running total and generally it is a smaller, daily number, which should be harder to misscalculate.

In MSSQL is easy to use TOP to get ordered states but if this was impossible in another language we could use rank () over function 

Top 10 states are below:

State	PercentPositive
IA	100
GU	10.3674094233713
NM	6.49047259361932
AK	6.20729878353608
PR	5.35436534745243
HI	4.96470588235294
NE	4.38969764837626
VI	4.38829787234043
NV	4.21501554864505
VA	4.02382551521793


3) The 7-day rolling average number of new cases per day for the last 30 days. 
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1 

In order to get more realistic number of the 7 day rolling average per day for the last 30 days, I have first isolated 37 days worth of data and
then calculated the 7 day rolling average of new cases for the last 30 days. This way - average for the day 30 is actually a real average based on the last 7 days prior to that and not just the actual number of new cases for that day.

Date	7DaysRollingAvg
2022-03-06	28014
2022-03-07	26342
2022-03-08	24633
2022-03-09	23053
2022-03-10	21702
2022-03-11	20549
2022-03-12	19732
2022-03-13	19363
2022-03-14	18981
2022-03-15	18770
2022-03-16	18651
2022-03-17	18913
2022-03-18	18960
2022-03-19	18984
2022-03-20	18999
2022-03-21	19090
2022-03-22	19086
2022-03-23	19302
2022-03-24	19080
2022-03-25	19110
2022-03-26	19340
2022-03-27	19423
2022-03-28	19531
2022-03-29	19437
2022-03-30	19065
2022-03-31	18207
2022-04-01	16284
