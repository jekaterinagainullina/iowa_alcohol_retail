SELECT DISTINCT
    item_number AS item_id,
    item_description,
    pack
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE date >= '2023-01-01'
  AND date < '2026-01-01'
