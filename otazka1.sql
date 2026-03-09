WITH cte_bez_duplicit AS (
	SELECT 
		tmv.odvetvi,
		tmv.prumerna_mzda,
		tmv.rok_mzda,
		lag(tmv.prumerna_mzda) OVER (PARTITION BY tmv.odvetvi ORDER BY tmv.rok_mzda ASC) AS mzda_predchozi_rok
	FROM t_matej_votipka_project_sql_primary_final tmv
	GROUP BY odvetvi, prumerna_mzda, rok_mzda
	ORDER BY odvetvi, rok_mzda),
	cte_vyvoj_mzdy AS (
	SELECT 
		bd.odvetvi,
		bd.prumerna_mzda,
		bd.rok_mzda,
		bd.mzda_predchozi_rok,
		CASE
			WHEN prumerna_mzda > mzda_predchozi_rok THEN 'růst'
			WHEN prumerna_mzda < mzda_predchozi_rok THEN 'pokles'
		END AS vyvoj
	FROM cte_bez_duplicit bd
	GROUP BY odvetvi, prumerna_mzda, rok_mzda, mzda_predchozi_rok
	ORDER BY odvetvi, rok_mzda)	
SELECT 
	vm.odvetvi,
	vm.rok_mzda,
	vm.prumerna_mzda,
	vm.mzda_predchozi_rok,
	vm.vyvoj 
FROM cte_vyvoj_mzdy vm
WHERE vm.vyvoj = 'pokles'
ORDER BY odvetvi, rok_mzda;