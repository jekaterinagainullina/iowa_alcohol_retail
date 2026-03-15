-- Some stores had multiple records with slightly different GPS coordinate rounding.
-- Simple DISTINCT does not work on geographic types in BigQuery.
-- Window function selects one record per store.
WITH stores AS (
    SELECT
        store_number,
        store_name,
        city,
        zip_code,
        store_location,
        ROW_NUMBER() OVER (
            PARTITION BY store_number
            ORDER BY
                IFNULL(ST_X(store_location), 0),
                IFNULL(ST_Y(store_location), 0)
        ) AS rn
    FROM `bigquery-public-data.iowa_liquor_sales.sales`
    WHERE date >= '2023-01-01'
      AND date < '2026-01-01'
)

SELECT
    store_number AS store_id,
    store_name,
    city,
    zip_code,
    store_location
FROM stores
WHERE rn = 1
