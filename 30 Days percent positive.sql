/*The 10 states with the highest test positivity rate (positive tests / tests performed) for tests performed in the last 30 days.
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1 
*/

DECLARE @30daysago as Date = (Select max(Cov.date) from Torch.CovidInfo Cov where Cov.Date < GETDATE()-30)

/* We will use sum of all Positive values from new_results_reported column and divide it by sum of all values from new_results_reported column 
to get the number of positive cases. This is easier than calculating what the status was on day 30 and finding the difference between that number
and number of cases yesterday. However if you dig deeper and compare these numbers these 2 columns dont match. In MSSQL is easy to use TOP to get ordered states 
but if this was impossible in another language we could use rank () over function */
								 
;with cte as 

			(SELECT DISTINCT state
				, SUM(case when overall_outcome = 'Positive' then new_results_reported else 0 END) over (partition by state) as PositivesReported
				, SUM(new_results_reported) over (partition by state) as TotalResultsReported

			FROM Torch.CovidInfo CI
			WHERE date >= @30daysago
			)

SELECT TOP 10 Fun.State, Fun.PercentPositive
FROM( SELECT c1.state
	   ,c1.PositivesReported
	   ,c1.TotalResultsReported
	   ,cast(c1.PositivesReported as float)/cast(c1.TotalResultsReported as float)*100  as PercentPositive
FROM cte c1) Fun
order by Fun.PercentPositive DESC
