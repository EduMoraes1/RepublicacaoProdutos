WITH

sales AS (
  SELECT
    buyer_id,
    received_at,
    state
  FROM
    `ninth-osprey-782.data_exports.bi_sales`s
  WHERE
    received_at IS NOT NULL
    AND DATE(received_at)=DATE_SUB(CURRENT_DATE(),INTERVAL 30 day)
    AND state='seller_paid' ),

  
users AS (
  SELECT
    user_id, email, name
  FROM
    `ninth-osprey-782.data_exports.bi_users`u ),
  
  
products AS (
  SELECT
    user_id,
    product_id,
    title
  FROM
    `ninth-osprey-782.data_exports.bi_products`p ),


price_ordering AS (
  SELECT
    DATE(sold_at) as sold_at,
    buyer_id,
    product_id,
    gross_product, 
    RANK() OVER(partition by buyer_id order by gross_product DESC) as order_pricing
  FROM `ninth-osprey-782.data_exports.bi_sales`
  WHERE DATE(sold_at) >= '2023-09-01' 
)

SELECT
  DISTINCT(p.user_id),
  DATE(received_at) AS received_at,
  u.email,
  po.order_pricing,
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
INNER JOIN
  price_ordering po
ON
  po.buyer_id=u.user_id
WHERE
  s.received_at IS NOT NULL
  AND DATE(received_at)=DATE_SUB(CURRENT_DATE(),INTERVAL 30 day)
  AND s.state='seller_paid'
  AND u.name NOT IN('desativada','removido')
  AND po.order_pricing=1
