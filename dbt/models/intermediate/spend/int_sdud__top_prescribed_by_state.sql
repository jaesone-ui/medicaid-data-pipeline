WITH staging AS (
    SELECT *
    FROM {{ ref('stg_sdud') }}
),

drug_annuals AS (
    SELECT
        calendar_year,
        us_state,
        ndc,
        MAX(product_name) AS product_name,
        SUM(prescriptions) AS number_of_prescriptions
    FROM staging
    GROUP BY calendar_year, us_state, ndc
),

drug_rankings AS (
    SELECT *,
        DENSE_RANK() OVER(PARTITION BY calendar_year, us_state ORDER BY number_of_prescriptions DESC) 
            AS prescription_rank
    FROM drug_annuals
)

SELECT *
FROM drug_rankings