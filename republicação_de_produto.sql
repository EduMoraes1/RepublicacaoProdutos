WITH


sales AS (
  SELECT
    buyer_id,
    received_at,
    state
  FROM
    `data_exports.sales`s
  WHERE
    received_at IS NOT NULL
    AND DATE(received_at)=DATE_SUB(CURRENT_DATE(),INTERVAL 30 day)
    AND state='seller_paid' ),
  

users AS (
  SELECT
    user_id, email, name
  FROM
    `data_exports.bi_users`u ),
  
  
products AS (
  SELECT
    user_id,
    product_id,
    title
  FROM
    `data_exports.bi_products`p ),


price_ordering as (
  SELECT
    DISTINCT(user_id),
    product_id,
    price,
    MAX(price) AS max_price
  FROM
    `data_exports.bi_products`p
  WHERE
    sold_at IS NOT NULL
  GROUP BY
    1,
    2,
    3)


SELECT
  DISTINCT(p.user_id),
  DATE(received_at) AS received_at,
  u.email,
  LOWER(SPLIT(u.name,' ')[ORDINAL(1)]) AS first_Name,
  CONCAT('https://www.enjoei.com.br/p/',(REGEXP_REPLACE(p.title, ' ', '-')),'-',p.product_id) AS product_url
FROM
  sales s
LEFT JOIN
  users u
ON
  s.buyer_id=u.user_id
INNER JOIN
  products p
ON
  s.buyer_id=p.user_id
WHERE
  s.received_at IS NOT NULL
  AND DATE(received_at)=DATE_SUB(CURRENT_DATE(),INTERVAL 30 day)
  AND s.state='seller_paid'
  AND u.name NOT IN('desativada','removido')