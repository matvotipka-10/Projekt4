SELECT 
	tmvpspf.nazev,
	tmvpspf.prumerna_mzda / tmvpspf.cena AS pocet,
	tmvpspf.merna_jednotka,
	tmvpspf.odvetvi,
	tmvpspf.rok_mzda
FROM t_matej_votipka_project_sql_primary_final tmvpspf 
WHERE tmvpspf.nazev IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované') 
	AND tmvpspf.rok_potravina IN (2006, 2018)
ORDER BY nazev, rok_potravina, odvetvi;