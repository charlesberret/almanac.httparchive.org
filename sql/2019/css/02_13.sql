#standardSQL
# 02_13: % of sites that use flexbox.
SELECT
  client,
  COUNT(DISTINCT url) AS freq,
  ROUND(COUNT(DISTINCT url) * 100 / total, 2) AS pct
FROM
  `httparchive.blink_features.features`
JOIN (SELECT _TABLE_SUFFIX AS client, COUNT(0) AS total FROM `httparchive.summary_pages.2019_07_01_*` GROUP BY client)
USING (client)
WHERE
  yyyymmdd = '20190701' AND
  feature = 'CSSFlexibleBox'
GROUP BY
  client,
  feature,
  total
