SELECT
    invoice_and_item_number AS invoice_id,
    date,
    bottle_volume_ml,
    state_bottle_cost,
    state_bottle_retail,
    bottles_sold,
    sale_dollars,
    store_number AS store_id,
    category AS category_id,
    item_number AS item_id,
    vendor_number AS vendor_id
FROM `bigquery-public-data.iowa_liquor_sales.sales`
WHERE date >= '2023-01-01'
  AND date < '2026-01-01'
  AND bottles_sold > 0                            -- exclude returns: negative bottle counts represent refunds, not sales
  AND invoice_and_item_number LIKE 'INV-%'        -- exclude 19 credit memo records with incorrectly positive values (accounting corrections, not actual sales)
  AND state_bottle_retail > state_bottle_cost     -- exclude 49 records with state_bottle_retail = 0 despite sale_dollars > 0 (data inconsistencies),
                                                  -- and remaining records where retail price is lower than cost price (data errors)
