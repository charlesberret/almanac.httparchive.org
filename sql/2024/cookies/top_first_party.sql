-- Extract top first party cookies that have the same name
-- They are probably from trackers that use 1st party cookies

WITH top_cookies AS (
    SELECT
        client,
        name,
        COUNT(DISTINCT first_party_host) as distinct_first_party_count
    FROM `httparchive.almanac.2024-06-01_top10k_cookies`
    WHERE 
        is_first_party = TRUE
    GROUP BY client, name
),
top_numbered_cookies AS (
    SELECT
        client,
        name,
        distinct_first_party_count,
        ROW_NUMBER() over (PARTITION BY client ORDER BY distinct_first_party_count DESC) AS row_num
    FROM top_cookies
)

SELECT 
    client,
    name,
    distinct_first_party_count,
    row_num
FROM top_numbered_cookies
WHERE row_num <= 100
ORDER BY client, row_num