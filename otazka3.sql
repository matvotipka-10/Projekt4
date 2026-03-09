WITH cte_cena_potravina_yty AS (
	SELECT 
		tmvpspf.nazev AS nazev, 
		tmvpspf.cena AS cena,  
		tmvpspf.rok_potravina AS rok_potravina,
		lag(tmvpspf.cena) OVER (PARTITION BY tmvpspf.nazev ORDER BY tmvpspf.rok_potravina) AS cena_predchozi_rok 
	FROM t_matej_votipka_project_sql_primary_final tmvpspf
	GROUP BY tmvpspf.nazev, tmvpspf.cena, tmvpspf.rok_potravina
	ORDER BY tmvpspf.nazev, rok_potravina 
), cte_zdrazeni_potravina_yty AS (
	SELECT
		ccpy.nazev,
		ccpy.cena,
		ccpy.rok_potravina,
		ccpy.cena_predchozi_rok,
		ccpy.cena - ccpy.cena_predchozi_rok AS zdrazeni_Kc,
		(ccpy.cena - ccpy.cena_predchozi_rok) / ccpy.cena_predchozi_rok * 100 AS procenta_zdrazeni
	FROM cte_cena_potravina_yty ccpy
), cte_prumer_zdrazeni AS (
	SELECT
		czpy.nazev AS nazev,
		avg(czpy.zdrazeni_kc) AS zdrazeni_kc,
		avg(czpy.procenta_zdrazeni) AS zdrazeni_procenta
	FROM cte_zdrazeni_potravina_yty czpy
	GROUP BY czpy.nazev
)
SELECT
	cpz.nazev,
	cpz.zdrazeni_kc,
	cpz.zdrazeni_procenta
FROM cte_prumer_zdrazeni cpz
ORDER BY cpz.zdrazeni_procenta