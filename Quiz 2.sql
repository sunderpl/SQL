DATABASE ua_dillards;

SHOW table strinfo;
HELP table strinfo;

SELECT DISTINCT *
FROM trnsact;

SELECT *
FROM trnsact
WHERE amt<>sprice;

/* Week 2 Question 5 */
SHOW table strinfo;

/* Week 2 Question 6 */
SELECT COUNT(*)
FROM strinfo
WHERE city IS NULL;
SELECT COUNT(*)
FROM strinfo
WHERE state IS NULL;
SELECT COUNT(*)
FROM strinfo
WHERE zip IS NULL;

/* Week 2 Question 7 */
SELECT sku, orgprice
FROM trnsact
ORDER BY orgprice DESC;

/* Week 2 Question 8 */
SELECT sku, brand, color
FROM skuinfo
WHERE brand='LIZ CLAI'
ORDER BY sku DESC;

/* Week 2 Question 9 */
SELECT sku, orgprice
FROM trnsact
ORDER BY orgprice
TOP 10;

/* Week 2 Question 10 */
SELECT COUNT(DISTINCT state)
FROM strinfo;

/* Week 2 Question 12 */
SELECT dept, deptdesc
FROM deptinfo
WHERE deptdesc LIKE ('e%');

/* Week 2 Question 13 */
SELECT saledate, sprice, orgprice, (sprice-orgprice) AS margin
FROM trnsact
WHERE sprice<>orgprice
ORDER BY saledate ASC, margin DESC;

/* Week 2 Question 14 */
SELECT register, orgprice, sprice
FROM trnsact
WHERE saledate BETWEEN '2004-08-01' AND '2004-08-10'
ORDER BY orgprice DESC, sprice DESC;

/* Week 2 Question 15 */
SELECT DISTINCT brand
FROM skuinfo
WHERE brand LIKE ('%liz%');

/* Week 2 Question 16 */
SELECT store, city
FROM store_msa
WHERE city IN('little rock','tulsa','memphis')
ORDER BY store ASC;