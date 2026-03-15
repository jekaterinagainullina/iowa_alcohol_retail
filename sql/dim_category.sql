SELECT DISTINCT
    category AS category_id,
    category_name
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE date >= '2023-01-01'
  AND date < '2026-01-01'
