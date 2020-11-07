DATABASE ua_dillards;

SELECT TOP 10 SUM(amt) revenue, saledate
FROM trnsact
WHERE stype='P'
GROUP BY saledate
ORDER BY revenue DESC;

SELECT TOP 10 COUNT(DISTINCT s.sku) AS skucount, d.deptdesc
FROM deptinfo d JOIN skuinfo s ON s.dept=d.dept
GROUP BY d.deptdesc
ORDER BY skucount DESC;

SELECT COUNT(DISTINCT sku)
FROM trnsact;
SELECT COUNT(DISTINCT sku)
FROM skuinfo;
SELECT COUNT(DISTINCT sku)
FROM skstinfo;

SELECT COUNT(DISTINCT st.sku)
FROM skstinfo st LEFT JOIN skuinfo sk ON st.sku=sk.sku
WHERE sk.sku IS NULL;

SELECT (SUM(t.amt)-SUM(s.cost))/COUNT(DISTINCT saledate) AS avgprofit
FROM trnsact t JOIN skstinfo s ON s.sku=t.sku AND s.store=t.store
WHERE t.stype='P';

SELECT COUNT(DISTINCT msa), MIN(msa_pop), MAX(msa_income)
SELECT msa, msa_pop, msa_income
FROM store_msa
WHERE state='NC';

SELECT TOP 10 SUM(t.amt) AS totalp, s.dept, s.brand, s.style, s.color, d.deptdesc
FROM trnsact t LEFT JOIN skuinfo s ON t.sku=s.sku JOIN deptinfo d ON s.dept=d.dept
WHERE t.stype='P'
GROUP BY s.dept, s.brand, s.style, s.color, d.deptdesc
ORDER BY totalp DESC;

SELECT store, COUNT(DISTINCT sku) AS skucount
FROM skstinfo
GROUP BY store
HAVING skucount>180000;

SELECT TOP 10 *
FROM skuinfo s JOIN deptinfo d ON s.dept=d.dept
WHERE d.deptdesc='cop' AND s.brand='federal' AND s.color='rinse wash';

SELECT COUNT(DISTINCT sk.sku)
FROM skuinfo sk LEFT JOIN skstinfo st ON st.sku=sk.sku
WHERE st.sku IS NULL;

SELECT TOP 10 s.store, s.city, s.state, SUM(t.amt)
FROM trnsact t JOIN store_msa s ON t.store=s.store
WHERE t.stype='P'
GROUP BY s.store, s.city, s.state
ORDER BY SUM(t.amt) DESC;

SELECT state, COUNT(store) AS storecount
FROM strinfo
GROUP BY state
HAVING storecount>10
ORDER BY storecount DESC;

SELECT TOP 100 t.retail, d.deptdesc, s.brand, s.color
FROM skstinfo t JOIN skuinfo s ON s.sku=t.sku JOIN deptinfo d ON s.dept=d.dept
WHERE d.deptdesc='reebok' AND s.brand='skechers' AND s.color='wht/saphire';
