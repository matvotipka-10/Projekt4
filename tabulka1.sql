CREATE TABLE IF NOT EXISTS t_matej_votipka_project_SQL_primary_final AS 
	WITH cte_uprava_format_rok AS (
		SELECT 
			cpc.name AS nazev,
			avg(cp.value) AS cena, 
			cpc.price_value AS mnozstvi,
			cpc.price_unit AS merna_jednotka,
			date_part('year', cp.date_from) AS rok_potravina
		FROM czechia_price cp 
		JOIN czechia_price_category cpc ON cp.category_code = cpc.code 
		GROUP BY rok_potravina, nazev, mnozstvi, merna_jednotka
	)	
	SELECT 
		ufr.nazev,
		ufr.cena,
		ufr.mnozstvi,
		ufr.merna_jednotka,
		ufr.rok_potravina,
		cpib.name AS odvetvi,
		avg(cp.value) AS prumerna_mzda, 
		cp.payroll_year AS rok_mzda
	FROM czechia_payroll cp 
	LEFT JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
	JOIN cte_uprava_format_rok ufr ON cp.payroll_year = ufr.rok_potravina
	WHERE cp.value_type_code = 5958 AND cp.calculation_code = 100
	GROUP BY rok_mzda, odvetvi, ufr.nazev, ufr.cena, ufr.mnozstvi, ufr.merna_jednotka, ufr.rok_potravina;