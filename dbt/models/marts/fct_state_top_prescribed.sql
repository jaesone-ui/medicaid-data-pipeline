WITH state_top_prescribed AS (
    SELECT *
    FROM {{ ref('int_sdud__state_top_prescribed') }}
)

SELECT
    to_hex(md5(concat(
        coalesce(us_state, '_null_'), '-',
        coalesce(cast(calendar_year AS string), '_null_'), '-',
        coalesce(ndc, '_null_')
    ))) AS state_top_prescribed_id,
    calendar_year,
    us_state,
    ndc,
    prescription_rank,
    number_of_prescriptions
FROM state_top_prescribed