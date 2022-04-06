/*The total number of PCR tests performed as of yesterday in the United States.
  -Author: Faruk Dziho
  -Date: 4/5/2022
  -Version: 1 
 */


DECLARE @asofyesterday as Date = (Select max(Cov.date) from Torch.CovidInfo Cov where Cov.Date < GETDATE()) 

/*@asofyesterday = Getting the most recent date from the table since there might not be any records inserted on the weekend or insert might be lagging */

SELECT sum(total_results_reported) as SumOfAllResults
FROM Torch.CovidInfo CI
WHERE date = @asofyesterday
