#standardSQL
# 13_15b: % of CDN usage for eComm - solely from Wapp
SELECT
  _TABLE_SUFFIX AS client,
  vendor,
  app,
  COUNTIF(category = 'CDN') AS CDNPlatfromFreq,
  SUM(COUNT(0)) OVER (PARTITION BY vendor) AS total,
  COUNTIF(category = 'CDN') / SUM(COUNT(0)) OVER (PARTITION BY vendor) AS pct
FROM
  `httparchive.technologies.2021_07_01_*`
JOIN (
  SELECT
    _TABLE_SUFFIX AS client,
    url,
    app AS vendor
  FROM
    `httparchive.technologies.2021_07_01_*`
  WHERE
    category = 'Ecommerce'
)
USING (url)
GROUP BY
  client,
  vendor,
  app
HAVING
  CDNPlatfromFreq > 0
ORDER BY
  total DESC,
  Vendor,
  CDNPlatfromFreq DESC
