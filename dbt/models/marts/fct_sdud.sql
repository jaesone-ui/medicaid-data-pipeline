WITH sdud AS (
    SELECT *
    FROM {{ ref('stg_sdud') }}
)

SELECT
    sdud_id,
    calendar_year,
    calendar_quarter,
    us_state,
    ndc,
    medicaid_amount_reimbursed,
    number_of_prescriptions,
    units_reimbursed
FROM sdud