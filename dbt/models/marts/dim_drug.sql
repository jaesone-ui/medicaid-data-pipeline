WITH sdud AS (
    SELECT *
    FROM {{ ref('stg_sdud') }}
),

recent_drug_rank AS (
    SELECT
        ndc,
        product_name,
        labeler_code,
        product_code,
        package_size,
        ROW_NUMBER() OVER (PARTITION BY ndc ORDER BY calendar_year DESC, calendar_quarter DESC) 
            AS recent_rank
        -- TODO: add drug classification from other sources (e.g., RxClass)
    FROM sdud
),

most_recent_drug AS (
    SELECT *
    FROM recent_drug_rank
    WHERE recent_rank = 1
)

SELECT 
    to_hex(md5(coalesce(ndc, '_null_'))) AS drug_id,
    ndc,
    product_name,
    labeler_code,
    product_code,
    package_size
FROM most_recent_drug
