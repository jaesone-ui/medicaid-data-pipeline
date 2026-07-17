WITH source AS (
    SELECT *
    FROM {{ source('sdud_raw', 'yearly_drug_utilization') }}
),

renamed AS (
    SELECT 
        -- create a primary key by concatenating state, year, quarter, and ndc
        to_hex(md5(concat(
            coalesce(utilization_type, '_null_'), '-',
            coalesce(state, '_null_'), '-',
            coalesce(cast(year AS string), '_null_'), '-',
            coalesce(cast(quarter AS string), '_null_'), '-',
            coalesce(ndc, '_null_')
        ))) AS sdud_id,
        utilization_type AS utilization_type,
        state AS us_state,
        ndc AS ndc,
        labeler_code AS labeler_code,
        product_code AS product_code,
        package_size AS package_size,
        year AS calendar_year,      
        quarter AS calendar_quarter,
        suppression_used AS suppression_used,
        UPPER(TRIM(product_name)) AS product_name,
        units_reimbursed AS units_reimbursed,
        number_of_prescriptions AS number_of_prescriptions,
        total_amount_reimbursed AS total_amount_reimbursed,
        medicaid_amount_reimbursed AS medicaid_amount_reimbursed,
        non_medicaid_amount_reimbursed AS non_medicaid_amount_reimbursed

    FROM source
),

cleaned AS (
    SELECT *
    FROM renamed
    WHERE NOT suppression_used
        AND us_state != 'XX'
)

SELECT *
FROM cleaned