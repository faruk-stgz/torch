/*The 7-day rolling average number of new cases per day for the last 30 days. 
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1 
*/

DECLARE @37daysago as Date = (Select max(Cov.date) from Torch.CovidInfo Cov where Cov.Date < GETDATE()-37)
DECLARE @30daysago as Date = (Select max(Cov.date) from Torch.CovidInfo Cov where Cov.Date < GETDATE()-30)

/* Declaring 37 days ago first in order for the Average value 30 days ago to be truly 7 day average and not just the actual number for that day
Both dates are formatted as date so there is no trailing minutes, seconds that would cause us to miss records */

;with	cte as (SELECT * 
				FROM Torch.CovidInfo TCI
				WHERE TCI.date >= @37daysago
				AND TCI.overall_outcome = 'Positive'
				)

/* Narrowing down the population to only show positive cases that happened 37 days ago and after, then summing those cases for all states partitioned by date */

,		cte1 as (SELECT DISTINCT date
								, sum(new_results_reported) over (partition by date) as SumNewCases
				 FROM cte
				 )

/* Getting the 7 days rolling average for the dates 30 days ago and after */

SELECT	Date, 
		[7DaysRollingAvg]

FROM	(SELECT	  Date
				, [7DaysRollingAvg] = avg(SumNewCases) over (order by date 
										  rows between 6 preceding and current row) 
		 FROM cte1) Fin
WHERE Date > @30daysago

