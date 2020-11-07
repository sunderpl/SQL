-- Quiz 5

-- Q2 13623
SELECT COUNT(DISTINCT sku)
  FROM skuinfo
  WHERE brand='Polo fas' AND (size='XXL' OR color='black');

-- Q3 Atlanta, GA
SELECT t.store, s.city, s.state, EXTRACT(MONTH from t.saledate) AS mth, EXTRACT(YEAR from t.saledate) AS yr
  FROM trnsact t JOIN strinfo s ON t.store=s.store
  GROUP BY t.store, mth, yr
  HAVING COUNT(DISTNCT t.saledate)=11;

-- Q4 3949538
SELECT  sku,
        SUM(CASE WHEN EXTRACT(MONTH from saledate)= 11 THEN amt END) AS nov_sales,
        SUM(CASE WHEN EXTRACT(MONTH from saledate)= 12 THEN amt END) AS dec_sales,
        dec_sales-nov_sales AS change
    FROM trnsact
    GROUP BY sku
    ORDER BY change DESC;

--Q5 5715232
SELECT COUNT(DISTINCT t.sku) num, sk.vendor
  FROM trnsact t JOIN skuinfo sk ON t.sku=sk.sku LEFT JOIN skstinfo st ON sk.sku=st.sku
  WHERE st.sku IS NULL
  GROUP BY sk.vendor
  ORDER BY num DESC;

-- Q6 Hart Sch
-- TOP and DISTINCT can't be used together.
  SELECT topstd.sku, topstd.stddev_sprice, s.brand, topstd.tran_num
  FROM
    (SELECT TOP 1 STDDEV_POP(t.sprice) as stddev_sprice, t.sku, COUNT(*) as tran_num
    FROM trnsact t
    GROUP BY t.sku
    HAVING COUNT(*)>100
    WHERE t.stype='p'
    ORDER BY stddev_sprice DESC) as topstd
  JOIN skuinfo s ON topstd.sku=s.sku
  ORDER BY topstd.stddev_sprice DESC;


-- Q7 Metairie LA
SELECT s.city, s.state, t.store,
    SUM(case WHEN EXTRACT(MONTH from saledate) =11 then amt END) as November,
    SUM(case WHEN EXTRACT(MONTH from saledate) =12 then amt END) as December,
    COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) =11 then saledate END)) as Nov_numdays,
    COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) =12 then saledate END)) as Dec_numdays,
    (December/Dec_numdays)-(November/Nov_numdays) AS dip
FROM trnsact t JOIN strinfo s
    ON t.store=s.store
WHERE t.stype='P'
    AND t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN
      (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
      FROM trnsact
      GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
      HAVING COUNT(DISTINCT saledate)>= 20)
GROUP BY s.city, s.state, t.store
ORDER BY dip DESC;


-- Q8 high: spanish fort AL. low: mcallen, TX. AL lower revenue than TX
SELECT  SUM(store_rev. tot_sales)/SUM(store_rev.numdays) AS daily_average,
        store_rev.msa_income as med_income,
        store_rev.city,
        store_rev.state
FROM (SELECT  COUNT (DISTINCT t.saledate) as numdays,
              sum(t.amt) as tot_sales,
              EXTRACT(YEAR from t.saledate) as s_year,
              EXTRACT(MONTH from t.saledate) as s_month,
              t.store,
              m.msa_income,
              s.city,
              s.state
              CASE  when extract(year from t.saledate) = 2005 AND extract(month from t.saledate) = 8
                    then 'exclude'
                    END as exclude_flag,
          FROM trnsact t JOIN store_msa m
          ON m.store=t.store JOIN strinfo s
          ON t.store=s.store
          WHERE t.stype = 'P' AND exclude_flag IS NULL
          GROUP BY s_year, s_month, t.store, m.msa_income, s.city, s.state
          HAVING numdays >= 20
        ) as store_rev
WHERE store_rev.msa_income IN ((SELECT MAX(msa_income) FROM store_msa),(SELECT MIN(msa_income) FROM store_msa))
GROUP BY med_income, store_rev.city, store_rev.state;


-- Q9 low
SELECT  SUM(revenue_per_store.revenue)/SUM(numdays) AS avg_group_revenue,
        CASE WHEN revenue_per_store.msa_income BETWEEN 1 AND 20000 THEN 'low'
             WHEN revenue_per_store.msa_income BETWEEN 20001 AND 30000 THEN 'med-low'
             WHEN revenue_per_store.msa_income BETWEEN 30001 AND 40000 THEN 'med-high'
             WHEN revenue_per_store.msa_income BETWEEN 40001 AND 60000 THEN 'high'
             END as income_group
FROM (SELECT m.msa_income, t.store,
             CASE when extract(year from t.saledate) = 2005 AND extract(month from t.saledate) = 8 then 'exclude' END as exclude_flag,
             SUM(t.amt) AS revenue,
             COUNT(DISTINCT t.saledate) as numdays,
             EXTRACT(MONTH from t.saledate) as monthID
         FROM store_msa m JOIN trnsact t
         ON m.store=t.store
         WHERE t.stype='P' AND exclude_flag IS NULL AND
             t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN
                (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
                  FROM trnsact
                  GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
                  HAVING COUNT(DISTINCT saledate)>= 20
                )
         GROUP BY t.store, m.msa_income, monthID, exclude_flag
       ) AS revenue_per_store
GROUP BY income_group
ORDER BY avg_group_revenue;


-- Q10 25452
SELECT  SUM(store_rev. tot_sales)/SUM(store_rev.numdays) AS daily_avg,
        CASE WHEN store_rev.msa_pop BETWEEN 1 AND 100000 THEN 'very small'
            WHEN store_rev.msa_pop BETWEEN 100001 AND 200000 THEN 'small'
            WHEN store_rev.msa_pop BETWEEN 200001 AND 500000 THEN 'med_small'
            WHEN store_rev.msa_pop BETWEEN 500001 AND 1000000 THEN 'med_large'
            WHEN store_rev.msa_pop BETWEEN 1000001 AND 5000000 THEN 'large'
            WHEN store_rev.msa_pop > 5000000 then 'very large'
            END as pop_group
FROM (SELECT COUNT (DISTINCT t.saledate) as numdays,
            EXTRACT(YEAR from t.saledate) as s_year,
            EXTRACT(MONTH from t.saledate) as s_month,
            t.store,
            sum(t.amt) AS tot_sales,
            CASE when extract(year from t.saledate) = 2005 AND extract(month from t.saledate) = 8 then 'exclude' END as exclude_flag, m.msa_pop
        FROM trnsact t JOIN store_msa m
        ON m.store=t.store
        WHERE t.stype = 'P' AND exclude_flag IS NULL
        GROUP BY s_year, s_month, t.store, m.msa_pop
        HAVING numdays >= 20
      ) as store_rev
GROUP BY pop_group
ORDER BY daily_avg;

-- Q11 Louisvl dept, salina, KS
SELECT  s.store,
        s.city,
        s.state,
        d.deptdesc,
        sum(case when extract(month from saledate)=11 then amt end) as November,
        COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='11' then saledate END)) as Nov_numdays,
        sum(case when extract(month from saledate)=12 then amt end) as December,
        COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='12' then saledate END)) as Dec_numdays,
        ((December/Dec_numdays)-(November/Nov_numdays))/(November/Nov_numdays)*100 AS bump
FROM trnsact t JOIN strinfo s
    ON t.store=s.store JOIN skuinfo si
    ON t.sku=si.sku JOIN deptinfo d
    ON si.dept=d.dept
WHERE t.stype='P' and t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate)
    IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
          FROM trnsact
          GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
          HAVING COUNT(DISTINCT saledate)>= 20
        )
GROUP BY
    s.store,
    s.city,
    s.state,
    d.deptdesc
HAVING November > 1000 AND December > 1000
ORDER BY bump DESC;

-- Q12 clinique, louisville, KY
SELECT  s.city,
        s.state,
        d.deptdesc,
        t.store,
        CASE when extract(year from t.saledate) = 2005 AND extract(month from t.saledate) = 8 then 'exclude'
          END as exclude_flag,
        SUM(case WHEN EXTRACT(MONTH from saledate) =’8’ THEN amt END) as August,
        SUM(case WHEN EXTRACT(MONTH from saledate) =’9’ THEN amt END) as September,
        COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='8' then saledate END)) as Aug_numdays,
        COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='9' then saledate END)) as Sept_numdays,
        (August/Aug_numdays)-(September/Sept_numdays) AS dip
FROM trnsact t JOIN strinfo s
    ON t.store=s.store JOIN skuinfo si
    ON t.sku=si.sku JOIN deptinfo d
    ON si.dept=d.dept
WHERE   t.stype='P'
        AND exclude_flag IS NULL
        AND t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate)
          IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
              FROM trnsact
              GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
              HAVING COUNT(DISTINCT saledate)>= 20
            )
GROUP BY s.city, s.state, d.deptdesc, t.store, exclude_flag
ORDER BY dip DESC;

-- Q13, Q14, Q15 TO DO (see feedback sheet)
