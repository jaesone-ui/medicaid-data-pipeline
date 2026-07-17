WITH high_cost_drugs AS (
    SELECT *
    FROM {{ ref('int_sdud__high_cost_drugs') }}
)

SELECT
    to_hex(md5(concat(
        coalesce(cast(calendar_year AS string), '_null_'), '-',
        coalesce(ndc, '_null_')
    ))) AS high_cost_drugs_id,
    calendar_year,
    ndc,
    is_high_cost_drug,
    reimbursed_per_drug,
    excess_amount
FROM high_cost_drugs