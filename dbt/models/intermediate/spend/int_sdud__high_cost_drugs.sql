WITH staging AS (
    SELECT *
    FROM {{ ref('stg_sdud') }}
),

drug_annuals AS (
    SELECT
        calendar_year,
        ndc,
        SUM(medicaid_amount_reimbursed) AS reimbursed_per_drug
    FROM staging
    GROUP BY calendar_year, ndc
),

aggregate_reimbursements AS (
    SELECT *,
        SUM(reimbursed_per_drug) OVER(PARTITION BY calendar_year) AS total_annual_reimbursed
    FROM drug_annuals
),

calculations AS (
    SELECT *,
        reimbursed_per_drug - (0.005 * total_annual_reimbursed) AS excess_amount,
        CASE
            WHEN reimbursed_per_drug - (0.005 * total_annual_reimbursed) > 0 THEN TRUE
            ELSE FALSE
        END AS is_high_cost_drug
    FROM aggregate_reimbursements
)

SELECT
    calendar_year,
    ndc,
    reimbursed_per_drug,
    is_high_cost_drug,
    excess_amount
FROM calculations 
ORDER BY reimbursed_per_drug DESC