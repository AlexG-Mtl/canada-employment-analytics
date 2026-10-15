
SELECT
    TO_DATE(ref_date || '-01', 'YYYY-MM-DD') AS employment_month,
    geo AS province,
    labour_force_characteristics AS indicator,
    gender,
    age_group,
    statistics,
    data_type,
    uom AS unit_of_measure,
    value AS indicator_value
FROM AI_DWH.CANADA_EMP_RAW.EMPLOYMENT_RAW
WHERE value IS NOT NULL
