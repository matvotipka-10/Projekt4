WITH cte_prumer_potravina AS (
	SELECT
		avg(cena) AS prumerna_cena,
		rok_potravina 
	FROM t_matej_votipka_project_sql_primary_final tmvpspf 
	GROUP BY rok_potravina
	ORDER BY rok_potravina 
), cte_prumer_potravina_yty AS (
	SELECT
		cpp.prumerna_cena,
		lag(cpp.prumerna_cena) OVER (ORDER BY cpp.rok_potravina) AS prumerna_cena_predchozi_rok,
		rok_potravina 
	FROM cte_prumer_potravina cpp
	ORDER BY cpp.prumerna_cena, cpp.rok_potravina	
), cte_prumer_mzdy AS (
	SELECT
		avg(prumerna_mzda) AS prumerna_mzda,
		rok_mzda 
	FROM t_matej_votipka_project_sql_primary_final tmvpspf 
	GROUP BY rok_mzda
	ORDER BY rok_mzda
), cte_prumer_mzdy_yty AS (
	SELECT
		cpm.prumerna_mzda,
		lag(cpm.prumerna_mzda) OVER (ORDER BY cpm.rok_mzda) AS prumerna_mzda_predchozi_rok,		
		rok_mzda 
	FROM cte_prumer_mzdy cpm
	ORDER BY cpm.prumerna_mzda, cpm.rok_mzda	
), cte_procenta_vyvoj AS (
	SELECT
		(cppy.prumerna_cena - cppy.prumerna_cena_predchozi_rok) / cppy.prumerna_cena_predchozi_rok * 100 AS vyvoj_ceny,
		(cpmy.prumerna_mzda - cpmy.prumerna_mzda_predchozi_rok) / cpmy.prumerna_mzda_predchozi_rok * 100 AS vyvoj_mzdy		
	FROM cte_prumer_potravina_yty cppy
	JOIN cte_prumer_mzdy_yty cpmy ON cppy.rok_potravina = cpmy.rok_mzda
)
SELECT
	cpv.vyvoj_ceny,
	cpv.vyvoj_mzdy,
	cpv.vyvoj_ceny - cpv.vyvoj_mzdy AS porovnani
FROM cte_procenta_vyvoj cpv
