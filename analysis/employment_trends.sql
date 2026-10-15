
-- Canada Employment Analytics
-- Source: Statistics Canada
-- Period: September 2024 - September 2026
-- Provinces: Quebec, Ontario, British Columbia

USE ROLE AI_DWH_ROLE;
USE WAREHOUSE AI_DWH_WH;

-- 1. Latest employment by province
SELECT
    province,
    employment_month,
    employed_thousands,
    mom_change_pct,
    yoy_change_pct
FROM AI_DWH.CANADA_EMP_MARTS.MART_EMPLOYMENT_TRENDS
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY province
    ORDER BY employment_month DESC
) = 1
ORDER BY province;


-- 2. Employment growth over the last 12 months
WITH ranked AS (
    SELECT
        province,
        employment_month,
        employed_thousands,
        yoy_change_pct
    FROM AI_DWH.CANADA_EMP_MARTS.MART_EMPLOYMENT_TRENDS
)
SELECT
    province,
    employment_month,
    employed_thousands,
    yoy_change_pct
FROM ranked
WHERE employment_month = (
    SELECT MAX(employment_month)
    FROM ranked
)
ORDER BY yoy_change_pct DESC;


-- 3. Employment trends by month
SELECT
    employment_month,
    province,
    employed_thousands,
    mom_change_pct,
    yoy_change_pct
FROM AI_DWH.CANADA_EMP_MARTS.MART_EMPLOYMENT_TRENDS
ORDER BY employment_month, province;
