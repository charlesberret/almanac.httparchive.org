

#standardSQL
# List all included government domains along with scores

WITH score_data AS (
  SELECT
    client,
    CAST(JSON_EXTRACT_SCALAR(lighthouse, '$.categories.performance.score') AS FLOAT64) AS performance_score,
    CAST(JSON_EXTRACT_SCALAR(lighthouse, '$.categories.accessibility.score') AS FLOAT64) AS accessibility_score,
    CAST(JSON_EXTRACT_SCALAR(lighthouse, '$.categories.best-practices.score') AS FLOAT64) AS best_practices_score,
    CAST(JSON_EXTRACT_SCALAR(lighthouse, '$.categories.seo.score') AS FLOAT64) AS seo_score,
    page,
    is_root_page,
    wptid
  FROM
    `httparchive.all.pages`
  WHERE
    date = '2024-06-01' AND
    lighthouse IS NOT NULL AND
    lighthouse != '{}'
),

domain_scores AS (
  SELECT
    page,
     CASE

       -- United Nations
      WHEN REGEXP_CONTAINS(page, r'\.un\.org/|\.worldbank\.org/|\.undp\.org/|\.reliefweb.int/|\.who.int/|\.unfccc.int/|\.unccd.int/|\.unesco.org/') THEN 'United Nations'
      WHEN REGEXP_CONTAINS(page, r'\.europa\.eu/') THEN 'European Union'

      -- North American States and Provinces
      WHEN REGEXP_CONTAINS(page, r'\.(alabama|al)\.gov/') THEN 'Alabama'
      WHEN REGEXP_CONTAINS(page, r'\.(alaska|ak)\.gov/') THEN 'Alaska'
      WHEN REGEXP_CONTAINS(page, r'\.(arizona|az)\.gov/') THEN 'Arizona'
      WHEN REGEXP_CONTAINS(page, r'\.(arkansas|ar)\.gov/') THEN 'Arkansas'
      WHEN REGEXP_CONTAINS(page, r'\.(california|ca)\.gov/') THEN 'California'
      WHEN REGEXP_CONTAINS(page, r'\.(colorado|co)\.gov/') THEN 'Colorado'
      WHEN REGEXP_CONTAINS(page, r'\.(connecticut|ct)\.gov/') THEN 'Connecticut'
      WHEN REGEXP_CONTAINS(page, r'\.(delaware|de)\.gov/') THEN 'Delaware'
      WHEN REGEXP_CONTAINS(page, r'\.(florida|fl)\.gov/|\.myflorida\.com/') THEN 'Florida'
      WHEN REGEXP_CONTAINS(page, r'\.(georgia|ga)\.gov/') THEN 'Georgia State' -- To avoid confusion with the country
      WHEN REGEXP_CONTAINS(page, r'\.(hawaii|hi|ehawaii)\.gov/') THEN 'Hawaii'
      WHEN REGEXP_CONTAINS(page, r'\.(idaho|id)\.gov/') THEN 'Idaho'
      WHEN REGEXP_CONTAINS(page, r'\.(illinois|il)\.gov/') THEN 'Illinois'
      WHEN REGEXP_CONTAINS(page, r'\.(indiana|in)\.gov/') THEN 'Indiana'
      WHEN REGEXP_CONTAINS(page, r'\.(iowa|ia)\.gov/') THEN 'Iowa'
      WHEN REGEXP_CONTAINS(page, r'\.(kansas|ks)\.gov/') THEN 'Kansas'
      WHEN REGEXP_CONTAINS(page, r'\.(kentucky|ky)\.gov/') THEN 'Kentucky'
      WHEN REGEXP_CONTAINS(page, r'\.(louisiana|la)\.gov/') THEN 'Louisiana'
      WHEN REGEXP_CONTAINS(page, r'\.(maine|me)\.gov/') THEN 'Maine'
      WHEN REGEXP_CONTAINS(page, r'\.(maryland|md)\.gov/') THEN 'Maryland'
      WHEN REGEXP_CONTAINS(page, r'\.(massachusetts|ma|mass)\.gov/') THEN 'Massachusetts'
      WHEN REGEXP_CONTAINS(page, r'\.(michigan|mi)\.gov/') THEN 'Michigan'
      WHEN REGEXP_CONTAINS(page, r'\.(minnesota|mn)\.gov/') THEN 'Minnesota'
      WHEN REGEXP_CONTAINS(page, r'\.(mississippi|ms)\.gov/') THEN 'Mississippi'
      WHEN REGEXP_CONTAINS(page, r'\.(missouri|mo)\.gov/') THEN 'Missouri'
      WHEN REGEXP_CONTAINS(page, r'\.(montana|mt)\.gov/') THEN 'Montana'
      WHEN REGEXP_CONTAINS(page, r'\.(nebraska|ne)\.gov/') THEN 'Nebraska'
      WHEN REGEXP_CONTAINS(page, r'\.(nevada|nv)\.gov/') THEN 'Nevada'
      WHEN REGEXP_CONTAINS(page, r'\.(newhampshire|nh)\.gov/') THEN 'New Hampshire'
      WHEN REGEXP_CONTAINS(page, r'\.(newjersey|nj)\.gov/') THEN 'New Jersey'
      WHEN REGEXP_CONTAINS(page, r'\.(newmexico|nm)\.gov/') THEN 'New Mexico'
      WHEN REGEXP_CONTAINS(page, r'\.(newyork|ny)\.gov/') THEN 'New York'
      WHEN REGEXP_CONTAINS(page, r'\.(northcarolina|nc)\.gov/') THEN 'North Carolina'
      WHEN REGEXP_CONTAINS(page, r'\.(northdakota|nd)\.gov/') THEN 'North Dakota'
      WHEN REGEXP_CONTAINS(page, r'\.(ohio|oh)\.gov/') THEN 'Ohio'
      WHEN REGEXP_CONTAINS(page, r'\.(oklahoma|ok)\.gov/') THEN 'Oklahoma'
      WHEN REGEXP_CONTAINS(page, r'\.(oregon|or)\.gov/') THEN 'Oregon'
      WHEN REGEXP_CONTAINS(page, r'\.(pennsylvania|pa)\.gov/') THEN 'Pennsylvania'
      WHEN REGEXP_CONTAINS(page, r'\.(rhodeisland|ri)\.gov/') THEN 'Rhode Island'
      WHEN REGEXP_CONTAINS(page, r'\.(southcarolina|sc)\.gov/') THEN 'South Carolina'
      WHEN REGEXP_CONTAINS(page, r'\.(southdakota|sd)\.gov/') THEN 'South Dakota'
      WHEN REGEXP_CONTAINS(page, r'\.(tennessee|tn)\.gov/') THEN 'Tennessee'
      WHEN REGEXP_CONTAINS(page, r'\.(texas|tx)\.gov/') THEN 'Texas'
      WHEN REGEXP_CONTAINS(page, r'\.(utah|ut)\.gov/') THEN 'Utah'
      WHEN REGEXP_CONTAINS(page, r'\.(vermont|vt)\.gov/') THEN 'Vermont'
      WHEN REGEXP_CONTAINS(page, r'\.(virginia)\.gov/') THEN 'Virginia'
      WHEN REGEXP_CONTAINS(page, r'\.(washington|wa)\.gov/') THEN 'Washington'
      WHEN REGEXP_CONTAINS(page, r'\.(washington|wa)\.gov/') THEN 'Washington'
      WHEN REGEXP_CONTAINS(page, r'\.(westvirginia|wv)\.gov/') THEN 'West Virginia'
      WHEN REGEXP_CONTAINS(page, r'\.(wisconsin|wi)\.gov/') THEN 'Wisconsin'
      WHEN REGEXP_CONTAINS(page, r'\.(wyoming|wy)\.gov/') THEN 'Wyoming'
      WHEN REGEXP_CONTAINS(page, r'\.dc\.gov/') THEN 'DC'
      WHEN REGEXP_CONTAINS(page, r'\.pr\.gov/') THEN 'Puerto Rico'
      WHEN REGEXP_CONTAINS(page, r'\.guam\.gov/') THEN 'Guam'
      WHEN REGEXP_CONTAINS(page, r'\.americansamoa\.gov/') THEN 'American Samoa'
      -- USA .gov domains need to be at the very end so that all other instances catch them.
      WHEN REGEXP_CONTAINS(page, r'\.mil/') THEN 'USA Military'
      WHEN REGEXP_CONTAINS(page, r'\.gob\.mx/') THEN 'Mexico'
      WHEN REGEXP_CONTAINS(page, r'\.(gc\.ca|canada\.ca|alberta\.ca|gov\.ab\.ca|gov\.bc\.ca|manitoba\.ca|gov\.mb\.ca|gnb\.ca|gov\.nb\.ca|gov\.nl\.ca|novascotia\.ca|gov\.ns\.ca|ontario\.ca|gov\.on\.ca|gov\.pe\.ca|quebec\.ca|gouv\.qc\.ca|revenuquebec\.ca|saskatchewan\.ca|gov\.sk\.ca|gov\.nt\.ca|gov\.nu\.ca|yukon\.ca|gov\.yk\.ca)/') THEN 'Canada'

      -- European Countries
      WHEN REGEXP_CONTAINS(page, r'\.gov\.al/') THEN 'Albania'
      WHEN REGEXP_CONTAINS(page, r'\.ax/') THEN 'Åland'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.ad/|\.govern\.ad/|\.exteriors\.ad/|\.consellgeneral\.ad/') THEN 'Andorra'
      WHEN REGEXP_CONTAINS(page, r'\.am/') THEN 'Armenia'
      WHEN REGEXP_CONTAINS(page, r'\.gv\.at/') THEN 'Austria'
      WHEN REGEXP_CONTAINS(page, r'\.az/') THEN 'Azerbaijan'
      WHEN REGEXP_CONTAINS(page, r'\.eus/') THEN 'Basque Country'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.by/') THEN 'Belarus'
      WHEN REGEXP_CONTAINS(page, r'\.belgium\.be/|\.gov\.be/|\.fgov\.be/|\.vlaanderen\.be/|\.wallonie\.be/|\.brussels\.be/|\.mil\.be/') THEN 'Belgium'
      WHEN REGEXP_CONTAINS(page, r'\.ba/') THEN 'Bosnia and Herzegovina'
      WHEN REGEXP_CONTAINS(page, r'\.government\.bg/') THEN 'Bulgaria'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.hr/') THEN 'Croatia'
      WHEN REGEXP_CONTAINS(page, r'\.cy/') THEN 'Cyprus'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.cz/') THEN 'Czechia (Czech Republic)'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.dk/|\.ft\.dk/|\.nemkonto\.dk/|\.nemlog-in\.dk/|\.mitid\.dk/|\.digst\.dk/|\.sikkerdigital\.dk/|\.forsvaret\.dk/|\.skat\.dk/|\.stps\.dk/|\.ufm\.dk/|\.urm\.dk/|\.uvm\.dk/|\.politi\.dk/|\.dataetiskraad\.dk/|\.at\.dk/|\.kum\.dk/') THEN 'Denmark'
      WHEN REGEXP_CONTAINS(page, r'\.riik\.ee/|\.riigiteataja\.ee/|\.eesti\.ee/|\.valitsus\.ee/') THEN 'Estonia'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.fi/|\.valtioneuvosto\.fi/|\.minedu\.fi/|\.formin\.fi/|\.intermin\.fi/|\.suomi\.fi/|\.ym\.fi/|\.stm\.fi/|\.tem\.fi/|\.lvm\.fi/|\.mmm\.fi/|\.okm\.fi/|\.vm\.fi/|\.defmin\.fi/|\.oikeusministerio\.fi/|\.um\.fi/|\.vero\.fi/|\.kela\.fi/') THEN 'Finland'
      WHEN REGEXP_CONTAINS(page, r'\.gouv\.fr/') THEN 'France'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.ge/') THEN 'Georgia Country'
      WHEN REGEXP_CONTAINS(page, r'\.bund\.de/') THEN 'Germany'
      WHEN REGEXP_CONTAINS(page, r'\.gi/') THEN 'Gibraltar'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.gr/') THEN 'Greece'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.hu/') THEN 'Hungary'
      WHEN REGEXP_CONTAINS(page, r'\.is/') THEN 'Iceland'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.ie/') THEN 'Ireland'
      WHEN REGEXP_CONTAINS(page, r'\.im/') THEN 'Isle of Man'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.it/|\.governo\.it/') THEN 'Italy'
      WHEN REGEXP_CONTAINS(page, r'\.kz/') THEN 'Kazakhstan'
      WHEN REGEXP_CONTAINS(page, r'\.lv/') THEN 'Latvia'
      WHEN REGEXP_CONTAINS(page, r'\.li/') THEN 'Liechtenstein'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.lt/|\.vrm\.lt/|\.sam\.lt/|\.ukmin\.lt/|\.lrv\.lt/|\.uzt\.lt/|\.migracija\.lt/|\.kam\.lt/|\.lrs\.lt/|\.urm\.lt/') THEN 'Lithuania'
      WHEN REGEXP_CONTAINS(page, r'\.public\.lu/|\.etat\.lu/') THEN 'Luxembourg'
      WHEN REGEXP_CONTAINS(page, r'\.mt/') THEN 'Malta'
      WHEN REGEXP_CONTAINS(page, r'\.md/') THEN 'Moldova'
      WHEN REGEXP_CONTAINS(page, r'\.mc/') THEN 'Monaco'
      WHEN REGEXP_CONTAINS(page, r'\.me/') THEN 'Montenegro'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.nl/|\.overheid\.nl/|\.mijnoverheid\.nl/') THEN 'Netherlands'
      WHEN REGEXP_CONTAINS(page, r'\.mk/') THEN 'Macedonia'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.no/') THEN 'Norway'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.pl/') THEN 'Poland'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.pt/') THEN 'Portugal'
      WHEN REGEXP_CONTAINS(page, r'\.ro/') THEN 'Romania'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.ru/|\.govvrn\.ru/') THEN 'Russia'
      WHEN REGEXP_CONTAINS(page, r'\.sm/') THEN 'San Marino'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.rs/') THEN 'Serbia'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.sk/') THEN 'Slovakia'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.si/') THEN 'Slovenia'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.es|gob\.es|ine\.es|boe\.es/') THEN 'Spain'
      WHEN REGEXP_CONTAINS(page, r'\.sj/') THEN 'Svalbard and Jan Mayen Islands'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.se/|\.1177\.se/|\.funktionstjanster\.se/|\.hemnet\.se/|\.smhi\.se/|\.sverigesradio\.se/|\.klart\.se/|\.bankid\.com/|\.synonymer\.se/|\.arbetsformedlingen\.se/|\.skatteverket\.se/|\.schoolsoft\.se/|\.postnord\.se/|\.grandid\.com/|\.viaplay\.se/|\.skola24\.se/|\.forsakringskassan\.se/|\.vklass\.se|sl\.se/|\.familjeliv\.se(/|\.$)') THEN 'Sweden'
      WHEN REGEXP_CONTAINS(page, r'\.admin\.ch/') THEN 'Switzerland'
      WHEN REGEXP_CONTAINS(page, r'\.gv\.ua/') THEN 'Ukraine'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.uk/') THEN 'United Kingdom (UK)'

      -- Other Countries
      WHEN REGEXP_CONTAINS(page, r'\.af/') THEN 'Afghanistan'
      WHEN REGEXP_CONTAINS(page, r'\.dz/') THEN 'Algeria'
      WHEN REGEXP_CONTAINS(page, r'\.as/') THEN 'American Samoa'
      WHEN REGEXP_CONTAINS(page, r'\.ao/') THEN 'Angola'
      WHEN REGEXP_CONTAINS(page, r'\.ai/') THEN 'Anguilla'
      WHEN REGEXP_CONTAINS(page, r'\.aq/') THEN 'Antarctica'
      WHEN REGEXP_CONTAINS(page, r'\.ag/') THEN 'Antigua and Barbuda'
      WHEN REGEXP_CONTAINS(page, r'\.gub\.ar/|\.gov\.ar/') THEN 'Argentina'
      WHEN REGEXP_CONTAINS(page, r'\.aw/') THEN 'Aruba'
      WHEN REGEXP_CONTAINS(page, r'\.ac/') THEN 'Ascension Island'
      WHEN REGEXP_CONTAINS(page, r'\.au/') THEN 'Australia'
      WHEN REGEXP_CONTAINS(page, r'\.bs/') THEN 'Bahamas'
      WHEN REGEXP_CONTAINS(page, r'\.bh/') THEN 'Bahrain'
      WHEN REGEXP_CONTAINS(page, r'\.bd/') THEN 'Bangladesh'
      WHEN REGEXP_CONTAINS(page, r'\.bb/') THEN 'Barbados'
      WHEN REGEXP_CONTAINS(page, r'\.bz/') THEN 'Belize'
      WHEN REGEXP_CONTAINS(page, r'\.bj/') THEN 'Benin'
      WHEN REGEXP_CONTAINS(page, r'\.bm/') THEN 'Bermuda'
      WHEN REGEXP_CONTAINS(page, r'\.bt/') THEN 'Bhutan'
      WHEN REGEXP_CONTAINS(page, r'\.bo/') THEN 'Bolivia'
      WHEN REGEXP_CONTAINS(page, r'\.bq/') THEN 'Bonaire'
      WHEN REGEXP_CONTAINS(page, r'\.bw/') THEN 'Botswana'
      WHEN REGEXP_CONTAINS(page, r'\.bv/') THEN 'Bouvet Island'
      WHEN REGEXP_CONTAINS(page, r'\.br/') THEN 'Brazil'
      WHEN REGEXP_CONTAINS(page, r'\.io/') THEN 'British Indian Ocean Territory'
      WHEN REGEXP_CONTAINS(page, r'\.vg/') THEN 'British Virgin Islands'
      WHEN REGEXP_CONTAINS(page, r'\.bn/') THEN 'Brunei'
      WHEN REGEXP_CONTAINS(page, r'\.bf/') THEN 'Burkina Faso'
      WHEN REGEXP_CONTAINS(page, r'\.mm/') THEN 'Burma (officially: Myanmar)'
      WHEN REGEXP_CONTAINS(page, r'\.bi/') THEN 'Burundi'
      WHEN REGEXP_CONTAINS(page, r'\.kh/') THEN 'Cambodia'
      WHEN REGEXP_CONTAINS(page, r'\.cm/') THEN 'Cameroon'
      WHEN REGEXP_CONTAINS(page, r'\.ca/') THEN 'Canada'
      WHEN REGEXP_CONTAINS(page, r'\.cv/') THEN 'Cape Verde (in Portuguese: Cabo Verde)'
      WHEN REGEXP_CONTAINS(page, r'\.cat/') THEN 'Catalonia'
      WHEN REGEXP_CONTAINS(page, r'\.ky/') THEN 'Cayman Islands'
      WHEN REGEXP_CONTAINS(page, r'\.cf/') THEN 'Central African Republic'
      WHEN REGEXP_CONTAINS(page, r'\.td/') THEN 'Chad'
      WHEN REGEXP_CONTAINS(page, r'\.cl/') THEN 'Chile'
      WHEN REGEXP_CONTAINS(page, r'\.cn/') THEN 'China'
      WHEN REGEXP_CONTAINS(page, r'\.cx/') THEN 'Christmas Island'
      WHEN REGEXP_CONTAINS(page, r'\.cc/') THEN 'Cocos (Keeling) Islands'
      WHEN REGEXP_CONTAINS(page, r'\.co/') THEN 'Colombia'
      WHEN REGEXP_CONTAINS(page, r'\.km/') THEN 'Comoros'
      WHEN REGEXP_CONTAINS(page, r'\.cd/') THEN 'Congo (Congo-Kinshasa)'
      WHEN REGEXP_CONTAINS(page, r'\.cg/') THEN 'Congo (Congo-Brazzaville)'
      WHEN REGEXP_CONTAINS(page, r'\.ck/') THEN 'Cook Islands'
      WHEN REGEXP_CONTAINS(page, r'\.cr/') THEN 'Costa Rica'
      WHEN REGEXP_CONTAINS(page, r'\.ci/') THEN 'Ivory Coast'
      WHEN REGEXP_CONTAINS(page, r'\.cu/') THEN 'Cuba'
      WHEN REGEXP_CONTAINS(page, r'\.cw/') THEN 'Curaçao'
      WHEN REGEXP_CONTAINS(page, r'\.dj/') THEN 'Djibouti'
      WHEN REGEXP_CONTAINS(page, r'\.dm/') THEN 'Dominica'
      WHEN REGEXP_CONTAINS(page, r'\.do/') THEN 'Dominican Republic'
      WHEN REGEXP_CONTAINS(page, r'\.tl/') THEN 'East Timor (Timor-Leste)'
      WHEN REGEXP_CONTAINS(page, r'\.tp/') THEN 'East Timor (Timor-Leste)'
      WHEN REGEXP_CONTAINS(page, r'\.ec/') THEN 'Ecuador'
      WHEN REGEXP_CONTAINS(page, r'\.eg/') THEN 'Egypt'
      WHEN REGEXP_CONTAINS(page, r'\.sv/') THEN 'El Salvador'
      WHEN REGEXP_CONTAINS(page, r'\.gq/') THEN 'Equatorial Guinea'
      WHEN REGEXP_CONTAINS(page, r'\.er/') THEN 'Eritrea'
      WHEN REGEXP_CONTAINS(page, r'\.et/') THEN 'Ethiopia'
      WHEN REGEXP_CONTAINS(page, r'\.eu/') THEN 'European Union'
      WHEN REGEXP_CONTAINS(page, r'\.fk/') THEN 'Falkland Islands'
      WHEN REGEXP_CONTAINS(page, r'\.fo/') THEN 'Faeroe Islands'
      WHEN REGEXP_CONTAINS(page, r'\.fm/') THEN 'Federated States of Micronesia'
      WHEN REGEXP_CONTAINS(page, r'\.fj/') THEN 'Fiji'
      WHEN REGEXP_CONTAINS(page, r'\.gf/') THEN 'French Guiana'
      WHEN REGEXP_CONTAINS(page, r'\.pf/') THEN 'French Polynesia'
      WHEN REGEXP_CONTAINS(page, r'\.tf/') THEN 'French Southern and Antarctic Lands'
      WHEN REGEXP_CONTAINS(page, r'\.ga/') THEN 'Gabon'
      WHEN REGEXP_CONTAINS(page, r'\.gal/') THEN 'Galicia'
      WHEN REGEXP_CONTAINS(page, r'\.gm/') THEN 'Gambia'
      WHEN REGEXP_CONTAINS(page, r'\.ps/') THEN 'Gaza'
      WHEN REGEXP_CONTAINS(page, r'\.gh/') THEN 'Ghana'
      WHEN REGEXP_CONTAINS(page, r'\.gl/') THEN 'Greenland'
      WHEN REGEXP_CONTAINS(page, r'\.gd/') THEN 'Grenada'
      WHEN REGEXP_CONTAINS(page, r'\.gp/') THEN 'Guadeloupe'
      WHEN REGEXP_CONTAINS(page, r'\.gu/') THEN 'Guam'
      WHEN REGEXP_CONTAINS(page, r'\.gt/') THEN 'Guatemala'
      WHEN REGEXP_CONTAINS(page, r'\.gg/') THEN 'Guernsey'
      WHEN REGEXP_CONTAINS(page, r'\.gn/') THEN 'Guinea'
      WHEN REGEXP_CONTAINS(page, r'\.gw/') THEN 'Guinea-Bissau'
      WHEN REGEXP_CONTAINS(page, r'\.gy/') THEN 'Guyana'
      WHEN REGEXP_CONTAINS(page, r'\.ht/') THEN 'Haiti'
      WHEN REGEXP_CONTAINS(page, r'\.hm/') THEN 'Heard Island'
      WHEN REGEXP_CONTAINS(page, r'\.hn/') THEN 'Honduras'
      WHEN REGEXP_CONTAINS(page, r'\.hk/') THEN 'Hong Kong'
      WHEN REGEXP_CONTAINS(page, r'\.gov\.in/|\.nic\.in/') THEN 'India'
      WHEN REGEXP_CONTAINS(page, r'\.id/') THEN 'Indonesia'
      WHEN REGEXP_CONTAINS(page, r'\.ir/') THEN 'Iran'
      WHEN REGEXP_CONTAINS(page, r'\.iq/') THEN 'Iraq'
      WHEN REGEXP_CONTAINS(page, r'\.il/') THEN 'Israel'
      WHEN REGEXP_CONTAINS(page, r'\.it/') THEN 'Italy'
      WHEN REGEXP_CONTAINS(page, r'\.jm/') THEN 'Jamaica'
      WHEN REGEXP_CONTAINS(page, r'\.jp/') THEN 'Japan'
      WHEN REGEXP_CONTAINS(page, r'\.je/') THEN 'Jersey'
      WHEN REGEXP_CONTAINS(page, r'\.jo/') THEN 'Jordan'
      WHEN REGEXP_CONTAINS(page, r'\.ke/') THEN 'Kenya'
      WHEN REGEXP_CONTAINS(page, r'\.ki/') THEN 'Kiribati'
      WHEN REGEXP_CONTAINS(page, r'\.kw/') THEN 'Kuwait'
      WHEN REGEXP_CONTAINS(page, r'\.kg/') THEN 'Kyrgyzstan'
      WHEN REGEXP_CONTAINS(page, r'\.la/') THEN 'Laos'
      WHEN REGEXP_CONTAINS(page, r'\.lb/') THEN 'Lebanon'
      WHEN REGEXP_CONTAINS(page, r'\.ls/') THEN 'Lesotho'
      WHEN REGEXP_CONTAINS(page, r'\.lr/') THEN 'Liberia'
      WHEN REGEXP_CONTAINS(page, r'\.ly/') THEN 'Libya'
      WHEN REGEXP_CONTAINS(page, r'\.mo/') THEN 'Macau'
      WHEN REGEXP_CONTAINS(page, r'\.mg/') THEN 'Madagascar'
      WHEN REGEXP_CONTAINS(page, r'\.mw/') THEN 'Malawi'
      WHEN REGEXP_CONTAINS(page, r'\.my/') THEN 'Malaysia'
      WHEN REGEXP_CONTAINS(page, r'\.mv/') THEN 'Maldives'
      WHEN REGEXP_CONTAINS(page, r'\.ml/') THEN 'Mali'
      WHEN REGEXP_CONTAINS(page, r'\.mh/') THEN 'Marshall Islands'
      WHEN REGEXP_CONTAINS(page, r'\.mq/') THEN 'Martinique'
      WHEN REGEXP_CONTAINS(page, r'\.mr/') THEN 'Mauritania'
      WHEN REGEXP_CONTAINS(page, r'\.mu/') THEN 'Mauritius'
      WHEN REGEXP_CONTAINS(page, r'\.yt/') THEN 'Mayotte'
      WHEN REGEXP_CONTAINS(page, r'\.mx/') THEN 'Mexico'
      WHEN REGEXP_CONTAINS(page, r'\.mn/') THEN 'Mongolia'
      WHEN REGEXP_CONTAINS(page, r'\.ms/') THEN 'Montserrat'
      WHEN REGEXP_CONTAINS(page, r'\.ma/') THEN 'Morocco'
      WHEN REGEXP_CONTAINS(page, r'\.mz/') THEN 'Mozambique'
      WHEN REGEXP_CONTAINS(page, r'\.mm/') THEN 'Myanmar'
      WHEN REGEXP_CONTAINS(page, r'\.na/') THEN 'Namibia'
      WHEN REGEXP_CONTAINS(page, r'\.nr/') THEN 'Nauru'
      WHEN REGEXP_CONTAINS(page, r'\.np/') THEN 'Nepal'
      WHEN REGEXP_CONTAINS(page, r'\.nl/') THEN 'Netherlands'
      WHEN REGEXP_CONTAINS(page, r'\.nc/') THEN 'New Caledonia'
      WHEN REGEXP_CONTAINS(page, r'\.nz/') THEN 'New Zealand'
      WHEN REGEXP_CONTAINS(page, r'\.ni/') THEN 'Nicaragua'
      WHEN REGEXP_CONTAINS(page, r'\.ne/') THEN 'Niger'
      WHEN REGEXP_CONTAINS(page, r'\.ng/') THEN 'Nigeria'
      WHEN REGEXP_CONTAINS(page, r'\.nu/') THEN 'Niue'
      WHEN REGEXP_CONTAINS(page, r'\.nf/') THEN 'Norfolk Island'
      WHEN REGEXP_CONTAINS(page, r'\.kp/') THEN 'North Korea'
      WHEN REGEXP_CONTAINS(page, r'\.mp/') THEN 'Northern Mariana Islands'
      WHEN REGEXP_CONTAINS(page, r'\.om/') THEN 'Oman'
      WHEN REGEXP_CONTAINS(page, r'\.pk/') THEN 'Pakistan'
      WHEN REGEXP_CONTAINS(page, r'\.pw/') THEN 'Palau'
      WHEN REGEXP_CONTAINS(page, r'\.ps/') THEN 'Palestine'
      WHEN REGEXP_CONTAINS(page, r'\.pa/') THEN 'Panama'
      WHEN REGEXP_CONTAINS(page, r'\.pg/') THEN 'Papua New Guinea'
      WHEN REGEXP_CONTAINS(page, r'\.py/') THEN 'Paraguay'
      WHEN REGEXP_CONTAINS(page, r'\.pe/') THEN 'Peru'
      WHEN REGEXP_CONTAINS(page, r'\.ph/') THEN 'Philippines'
      WHEN REGEXP_CONTAINS(page, r'\.pn/') THEN 'Pitcairn Islands'
      WHEN REGEXP_CONTAINS(page, r'\.pr/') THEN 'Puerto Rico'
      WHEN REGEXP_CONTAINS(page, r'\.qa/') THEN 'Qatar'
      WHEN REGEXP_CONTAINS(page, r'\.rw/') THEN 'Rwanda'
      WHEN REGEXP_CONTAINS(page, r'\.re/') THEN 'Réunion Island'
      WHEN REGEXP_CONTAINS(page, r'\.sh/') THEN 'Saint Helena'
      WHEN REGEXP_CONTAINS(page, r'\.kn/') THEN 'Saint Kitts and Nevis'
      WHEN REGEXP_CONTAINS(page, r'\.lc/') THEN 'Saint Lucia'
      WHEN REGEXP_CONTAINS(page, r'\.pm/') THEN 'Saint-Pierre and Miquelon'
      WHEN REGEXP_CONTAINS(page, r'\.vc/') THEN 'Saint Vincent and the Grenadines'
      WHEN REGEXP_CONTAINS(page, r'\.ws/') THEN 'Samoa'
      WHEN REGEXP_CONTAINS(page, r'\.st/') THEN 'São Tomé and Príncipe'
      WHEN REGEXP_CONTAINS(page, r'\.sa/') THEN 'Saudi Arabia'
      WHEN REGEXP_CONTAINS(page, r'\.sn/') THEN 'Senegal'
      WHEN REGEXP_CONTAINS(page, r'\.sc/') THEN 'Seychelles'
      WHEN REGEXP_CONTAINS(page, r'\.sl/') THEN 'Sierra Leone'
      WHEN REGEXP_CONTAINS(page, r'\.sg/') THEN 'Singapore'
      WHEN REGEXP_CONTAINS(page, r'\.sx/') THEN 'Sint Maarten'
      WHEN REGEXP_CONTAINS(page, r'\.sb/') THEN 'Solomon Islands'
      WHEN REGEXP_CONTAINS(page, r'\.so/') THEN 'Somalia'
      WHEN REGEXP_CONTAINS(page, r'\.za/') THEN 'South Africa'
      WHEN REGEXP_CONTAINS(page, r'\.gs/') THEN 'South Georgia and the South Sandwich Islands'
      WHEN REGEXP_CONTAINS(page, r'\.kr/') THEN 'South Korea'
      WHEN REGEXP_CONTAINS(page, r'\.ss/') THEN 'South Sudan'
      WHEN REGEXP_CONTAINS(page, r'\.es/') THEN 'Spain'
      WHEN REGEXP_CONTAINS(page, r'\.lk/') THEN 'Sri Lanka'
      WHEN REGEXP_CONTAINS(page, r'\.sd/') THEN 'Sudan'
      WHEN REGEXP_CONTAINS(page, r'\.sr/') THEN 'Suriname'
      WHEN REGEXP_CONTAINS(page, r'\.sz/') THEN 'Swaziland'
      WHEN REGEXP_CONTAINS(page, r'\.se/') THEN 'Sweden'
      WHEN REGEXP_CONTAINS(page, r'\.sy/') THEN 'Syria'
      WHEN REGEXP_CONTAINS(page, r'\.tw/') THEN 'Taiwan'
      WHEN REGEXP_CONTAINS(page, r'\.tj/') THEN 'Tajikistan'
      WHEN REGEXP_CONTAINS(page, r'\.tz/') THEN 'Tanzania'
      WHEN REGEXP_CONTAINS(page, r'\.th/') THEN 'Thailand'
      WHEN REGEXP_CONTAINS(page, r'\.tg/') THEN 'Togo'
      WHEN REGEXP_CONTAINS(page, r'\.tk/') THEN 'Tokelau'
      WHEN REGEXP_CONTAINS(page, r'\.to/') THEN 'Tonga'
      WHEN REGEXP_CONTAINS(page, r'\.tt/') THEN 'Trinidad & Tobago'
      WHEN REGEXP_CONTAINS(page, r'\.tn/') THEN 'Tunisia'
      WHEN REGEXP_CONTAINS(page, r'\.tr/') THEN 'Turkey'
      WHEN REGEXP_CONTAINS(page, r'\.tm/') THEN 'Turkmenistan'
      WHEN REGEXP_CONTAINS(page, r'\.tc/') THEN 'Turks and Caicos Islands'
      WHEN REGEXP_CONTAINS(page, r'\.tv/') THEN 'Tuvalu'
      WHEN REGEXP_CONTAINS(page, r'\.ug/') THEN 'Uganda'
      WHEN REGEXP_CONTAINS(page, r'\.ua/') THEN 'Ukraine'
      WHEN REGEXP_CONTAINS(page, r'\.ae/') THEN 'United Arab Emirates (UAE)'
      WHEN REGEXP_CONTAINS(page, r'\.vi/') THEN 'United States Virgin Islands'
      WHEN REGEXP_CONTAINS(page, r'\.uy/') THEN 'Uruguay'
      WHEN REGEXP_CONTAINS(page, r'\.uz/') THEN 'Uzbekistan'
      WHEN REGEXP_CONTAINS(page, r'\.vu/') THEN 'Vanuatu'
      WHEN REGEXP_CONTAINS(page, r'\.va/') THEN 'Vatican City'
      WHEN REGEXP_CONTAINS(page, r'\.ve/') THEN 'Venezuela'
      WHEN REGEXP_CONTAINS(page, r'\.vn/') THEN 'Vietnam'
      WHEN REGEXP_CONTAINS(page, r'\.wf/') THEN 'Wallis and Futuna'
      WHEN REGEXP_CONTAINS(page, r'\.eh/') THEN 'Western Sahara'
      WHEN REGEXP_CONTAINS(page, r'\.ye/') THEN 'Yemen'
      WHEN REGEXP_CONTAINS(page, r'\.zm/') THEN 'Zambia'
      WHEN REGEXP_CONTAINS(page, r'\.zw/') THEN 'Zimbabwe'

      -- All other .gov defintions will be American
      WHEN REGEXP_CONTAINS(page, r'\.gov') THEN 'United States (USA)'

      ELSE 'Other'
    END AS gov_domain,
    is_root_page,
    performance_score,
    accessibility_score,
    best_practices_score,
    seo_score,
    wptid
  FROM
    score_data
  WHERE
    REGEXP_CONTAINS(page, r'(?i)('
      '(\\w+\\.)*\\.un\\.org(/|$)'  -- United Nations and International Organizations
      '|(\\w+\\.)*\\.worldbank\\.org(/|$)'
      '|(\\w+\\.)*\\.undp\\.org(/|$)'
      '|(\\w+\\.)*\\.reliefweb\\.int(/|$)'
      '|(\\w+\\.)*\\.who\\.int(/|$)'
      '|(\\w+\\.)*\\.unfccc\\.int(/|$)'
      '|(\\w+\\.)*\\.unccd\\.int(/|$)'
      '|(\\w+\\.)*\\.unesco\\.org(/|$)'

      '|(\\w+\\.)*\\.europa\\.eu(/|$)'  -- European Union

      '|(\\w+\\.)*\\.gov(\\.[a-z]{2,3})?(/|$)'  -- US Government and global .gov domains (e.g., .gov.uk, .gov.au)
      '|(\\w+\\.)*\\.mil(\\.[a-z]{2,3})?(/|$)'  -- US Military and global .mil domains

      '|(\\w+\\.)*\\.myflorida\\.com(/|$)' -- Florida

      '|(\\w+\\.){0,2}(gov|mil|gouv|gob|gub|go|govt|gv|nic|government)\\.(taipei|[a-z]{2})?(/|$)' -- Other generic government formats (e.g., gouv.fr, gob.mx, go.jp)

      '|(\\w+\\.)*\\.gc\\.ca(/|$)'  -- Canada and provinces
      '|(\\w+\\.)*\\.canada\\.ca(/|$)'
      '|(\\w+\\.)*\\.alberta\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.ab\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.bc\\.ca(/|$)'
      '|(\\w+\\.)*\\.manitoba\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.mb\\.ca(/|$)'
      '|(\\w+\\.)*\\.gnb\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.nb\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.nl\\.ca(/|$)'
      '|(\\w+\\.)*\\.novascotia\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.ns\\.ca(/|$)'
      '|(\\w+\\.)*\\.ontario\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.on\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.pe\\.ca(/|$)'
      '|(\\w+\\.)*\\.quebec\\.ca(/|$)'
      '|(\\w+\\.)*\\.gouv\\.qc\\.ca(/|$)'
      '|(\\w+\\.)*\\.revenuquebec\\.ca(/|$)'
      '|(\\w+\\.)*\\.saskatchewan\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.sk\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.nt\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.nu\\.ca(/|$)'
      '|(\\w+\\.)*\\.yukon\\.ca(/|$)'
      '|(\\w+\\.)*\\.gov\\.yk\\.ca(/|$)'

      '|(\\w+\\.)*\\.bund\\.de(/|$)'  -- Germany

      '|(\\w+\\.)*\\.belgium\\.be(/|$)'  -- Belgium
      '|(\\w+\\.)*\\.fgov\\.be(/|$)'
      '|(\\w+\\.)*\\.vlaanderen\\.be(/|$)'
      '|(\\w+\\.)*\\.wallonie\\.be(/|$)'
      '|(\\w+\\.)*\\.brussels\\.be(/|$)'
      '|(\\w+\\.)*\\.mil\\.be(/|$)'

      '|(\\w+\\.)*\\.gov\\.se(/|$)'  -- Sweden
      '|(\\w+\\.)*\\.1177\\.se(/|$)'
      '|(\\w+\\.)*\\.funktionstjanster\\.se(/|$)'
      '|(\\w+\\.)*\\.hemnet\\.se(/|$)'
      '|(\\w+\\.)*\\.smhi\\.se(/|$)'
      '|(\\w+\\.)*\\.sverigesradio\\.se(/|$)'
      '|(\\w+\\.)*\\.klart\\.se(/|$)'
      '|(\\w+\\.)*\\.bankid\\.com(/|$)'
      '|(\\w+\\.)*\\.synonymer\\.se(/|$)'
      '|(\\w+\\.)*\\.arbetsformedlingen\\.se(/|$)'
      '|(\\w+\\.)*\\.skatteverket\\.se(/|$)'
      '|(\\w+\\.)*\\.schoolsoft\\.se(/|$)'
      '|(\\w+\\.)*\\.postnord\\.se(/|$)'
      '|(\\w+\\.)*\\.grandid\\.com(/|$)'
      '|(\\w+\\.)*\\.viaplay\\.se(/|$)'
      '|(\\w+\\.)*\\.skola24\\.se(/|$)'
      '|(\\w+\\.)*\\.forsakringskassan\\.se(/|$)'
      '|(\\w+\\.)*\\.vklass\\.se(/|$)'
      '|(\\w+\\.)*\\.sl\\.se(/|$)'
      '|(\\w+\\.)*\\.familjeliv\\.se(/|$)'

      '|(\\w+\\.)*\\.valtioneuvosto\\.fi(/|$)'  -- Finland
      '|(\\w+\\.)*\\.minedu\\.fi(/|$)'
      '|(\\w+\\.)*\\.formin\\.fi(/|$)'
      '|(\\w+\\.)*\\.intermin\\.fi(/|$)'
      '|(\\w+\\.)*\\.suomi\\.fi(/|$)'
      '|(\\w+\\.)*\\.ym\\.fi(/|$)'
      '|(\\w+\\.)*\\.stm\\.fi(/|$)'
      '|(\\w+\\.)*\\.tem\\.fi(/|$)'
      '|(\\w+\\.)*\\.lvm\\.fi(/|$)'
      '|(\\w+\\.)*\\.mmm\\.fi(/|$)'
      '|(\\w+\\.)*\\.okm\\.fi(/|$)'
      '|(\\w+\\.)*\\.vm\\.fi(/|$)'
      '|(\\w+\\.)*\\.defmin\\.fi(/|$)'
      '|(\\w+\\.)*\\.oikeusministerio\\.fi(/|$)'
      '|(\\w+\\.)*\\.um\\.fi(/|$)'
      '|(\\w+\\.)*\\.vero\\.fi(/|$)'
      '|(\\w+\\.)*\\.kela\\.fi(/|$)'

      '|(\\w+\\.)*\\.lrv\\.lt(/|$)'  -- Lithuania
      '|(\\w+\\.)*\\.uzt\\.lt(/|$)'
      '|(\\w+\\.)*\\.migracija\\.lt(/|$)'
      '|(\\w+\\.)*\\.kam\\.lt(/|$)'
      '|(\\w+\\.)*\\.lrs\\.lt(/|$)'
      '|(\\w+\\.)*\\.urm\\.lt(/|$)'

      '|(\\w+\\.)*\\.riik\\.ee(/|$)'  -- Estonia
      '|(\\w+\\.)*\\.riigiteataja\\.ee(/|$)'
      '|(\\w+\\.)*\\.eesti\\.ee(/|$)'
      '|(\\w+\\.)*\\.valitsus\\.ee(/|$)'

      '|(\\w+\\.)*\\.admin\\.ch(/|$)'  -- Switzerland

      '|(\\w+\\.)*\\.seg-social\\.es(/|$)'  -- Spain
      '|(\\w+\\.)*\\.ine\\.es(/|$)'
      '|(\\w+\\.)*\\.boe\\.es(/|$)'

      '|(\\w+\\.)*\\.ft\\.dk(/|$)'  -- Denmark
      '|(\\w+\\.)*\\.nemkonto\\.dk(/|$)'
      '|(\\w+\\.)*\\.nemlog-in\\.dk(/|$)'
      '|(\\w+\\.)*\\.mitid\\.dk(/|$)'
      '|(\\w+\\.)*\\.digst\\.dk(/|$)'
      '|(\\w+\\.)*\\.sikkerdigital\\.dk(/|$)'
      '|(\\w+\\.)*\\.forsvaret\\.dk(/|$)'
      '|(\\w+\\.)*\\.skat\\.dk(/|$)'
      '|(\\w+\\.)*\\.stps\\.dk(/|$)'
      '|(\\w+\\.)*\\.ufm\\.dk(/|$)'
      '|(\\w+\\.)*\\.urm\\.dk(/|$)'
      '|(\\w+\\.)*\\.uvm\\.dk(/|$)'
      '|(\\w+\\.)*\\.politi\\.dk(/|$)'
      '|(\\w+\\.)*\\.dataetiskraad\\.dk(/|$)'
      '|(\\w+\\.)*\\.at\\.dk(/|$)'
      '|(\\w+\\.)*\\.kum\\.dk(/|$)'

      '|(\\w+\\.)*\\.govvrn\\.ru(/|$)' -- Russia

      '|(\\w+\\.)*\\.public\\.lu(/|$)'  -- Luxembourg
      '|(\\w+\\.)*\\.etat\\.lu(/|$)'

      '|(\\w+\\.)*\\.governo\\.it(/|$)'  -- Italy

      '|(\\w+\\.)*\\.overheid\\.nl(/|$)'  -- Netherlands
      '|(\\w+\\.)*\\.mijnoverheid\\.nl(/|$)'

      '|(\\w+\\.)*\\.govern\\.ad(/|$)'  -- Andorra
      '|(\\w+\\.)*\\.exteriors\\.ad(/|$)'
      '|(\\w+\\.)*\\.consellgeneral\\.ad(/|$)'

      ')')
)

SELECT
  gov_domain,
  page,
  is_root_page,
  performance_score,
  accessibility_score,
  best_practices_score,
  seo_score,
  wptid
FROM
  domain_scores
WHERE gov_domain IS NOT NULL
ORDER BY gov_domain;
