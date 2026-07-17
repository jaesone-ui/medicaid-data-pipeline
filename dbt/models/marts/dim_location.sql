WITH sdud AS (
    SELECT *
    FROM {{ ref('stg_sdud') }}
),

us_states_seed AS (
    SELECT *
    FROM {{ ref('us_states') }}
),

distinct_states AS (
    SELECT DISTINCT(us_state)
    FROM sdud
)


SELECT
    to_hex(md5(coalesce(fact.us_state, '_null_'))) AS location_id,
    fact.us_state,
    seed.state_name,
    seed.state_region
FROM distinct_states AS fact
LEFT JOIN us_states_seed AS seed
    ON fact.us_state = seed.state_code
