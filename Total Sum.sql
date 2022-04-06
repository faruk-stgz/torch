/*The total number of PCR tests performed as of yesterday in the United States.
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1.1 
 */


/*DECLARE @asofyesterday as Date = (Select max(Cov.date) from Torch.CovidInfo Cov where Cov.Date < GETDATE()) 
@asofyesterday = Getting the most recent date from the table since there might not be any records inserted on the weekend or insert might be lagging 
this is the wrong approach - some states are few days behind and their sums would be missed looking only at sums at @asofyesterday

Instead creating distinct state list with most recent dates and using it to join down in the query
*/



; with cte as ( Select distinct state , max(date) as maxdate
				from Torch.CovidInfo CI
				where date < getdate()
				group by state)



SELECT sum(total_results_reported) as SumOfAllResults
FROM Torch.CovidInfo CI
join cte c2 on ci.date = c2.maxdate
			      and ci.state = c2.state



