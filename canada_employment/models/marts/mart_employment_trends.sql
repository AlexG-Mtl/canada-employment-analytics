
WITH employment AS (
    SELECT
        employment_month,
        province,
        indicator_value AS employed_thousands
    FROM {{ ref('stg_employment') }}
    WHERE indicator = 'Employment'
      AND gender = 'Total - Gender'
      AND age_group = '15 years and over'
      AND statistics = 'Estimate'
      AND unit_of_measure = 'Persons in thousands'
      AND data_type = 'Seasonally adjusted'
),

trends AS (
    SELECT
        employment_month,
        province,
        employed_thousands,
        LAG(employed_thousands, 1) OVER (
            PARTITION BY province
            ORDER BY employment_month
        ) AS previous_month,
        LAG(employed_thousands, 12) OVER (
            PARTITION BY province
            ORDER BY employment_month
        ) AS previous_year
    FROM employment
)

SELECT
    employment_month,
    province,
    employed_thousands,
    ROUND(
        100 * (employed_thousands - previous_month)
        / NULLIF(previous_month, 0), 2
    ) AS mom_change_pct,
    ROUND(
        100 * (employed_thousands - previous_year)
        / NULLIF(previous_year, 0), 2
    ) AS yoy_change_pct
FROM trends
