CREATE TABLE  IF NOT EXISTS t_matej_votipka_project_SQL_secondary_final AS
	SELECT DISTINCT
		e.country,
		e.YEAR,
		e.gdp,
		e.gini,
		e.population
	FROM economies e
	JOIN countries c ON e.country = c.country 
	JOIN t_matej_votipka_project_sql_primary_final tmvpspf ON e.year = tmvpspf.rok_mzda
	WHERE c.continent = 'Europe'