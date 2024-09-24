CREATE TEMPORARY FUNCTION getResourceHints(payload STRING)
RETURNS ARRAY < STRUCT < name STRING, href STRING >>
LANGUAGE js AS '''
var hints = new Set(['preload', 'prefetch', 'preconnect', 'prerender', 'dns-prefetch']);
try {
    var $ = JSON.parse(payload);
    var almanac = JSON.parse($._almanac);
    return almanac['link-nodes'].nodes.reduce((results, link) => {
        var hint = link.rel.toLowerCase();
        if (!hints.has(hint)) {
            return results;
        }
        results.push({
            name: hint,
            href: link.href
        });
        return results;
    }, []);
} catch (e) {
    return [];
}
''';

WITH resource_hints AS (
  SELECT DISTINCT
    client,
    page,
    date,
    hint.name AS name
  FROM
    `httparchive.all.pages`
  LEFT JOIN
    UNNEST(getResourceHints(payload)) AS hint
  WHERE
    (date = '2024-06-01' OR date = '2023-06-01' OR date = '2022-06-01')
    AND is_root_page
),

totals AS (
  SELECT
    client,
    date,
    COUNT(0) AS total_pages
  FROM
    `httparchive.all.pages`
  WHERE
    (date = '2024-06-01' OR date = '2023-06-01' OR date = '2022-06-01')
    AND is_root_page
  GROUP BY
    client,
    date
)

SELECT
  client,
  date,
  name,
  COUNT(DISTINCT page) AS pages,
  ANY_VALUE(total_pages) AS total,
  COUNT(DISTINCT page) / ANY_VALUE(total_pages) AS pct,
FROM
  resource_hints
JOIN
  totals
USING
  (client, date)
GROUP BY 
  client,
  date,
  name
ORDER BY
  client,
  date,
  name DESC
