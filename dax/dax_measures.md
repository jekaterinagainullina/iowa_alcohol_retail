# DAX Measures — Iowa Liquor Sales

All measures are organized by category. Created in Power BI Desktop using a dedicated `_Measures` table.

---

## Base Metrics

```dax
Total Revenue = SUM(Sales[sale_dollars])

Total Bottles = SUM(Sales[bottles_sold])

Total Transactions = DISTINCTCOUNT(Sales[invoice_ID])

Total Margin = SUM(Sales[total_margin])

Total Volume L = SUM(Sales[total_volume_l])

Active Stores = DISTINCTCOUNT(Sales[store_ID])

Active Vendors = DISTINCTCOUNT(Sales[vendor_ID])
```

---

## Average Metrics

```dax
AOV =
DIVIDE([Total Revenue], [Total Transactions], 0)

Avg Bottle Cost =
AVERAGE(Sales[state_bottle_cost])

Avg Retail Price =
AVERAGE(Sales[state_bottle_retail])

Avg Margin per Bottle =
[Avg Retail Price] - [Avg Bottle Cost]

Avg Margin per Bottle % =
DIVIDE([Avg Retail Price] - [Avg Bottle Cost], [Avg Bottle Cost], 0)

Avg Bottles per Store =
DIVIDE([Total Bottles], [Active Stores], 0)

Avg Revenue per Store =
DIVIDE([Total Revenue], [Active Stores], 0)

Avg Monthly Revenue =
AVERAGEX(VALUES(Calendar[Year-Month]), [Total Revenue])
```

---

## Margin

```dax
Margin % =
DIVIDE([Total Margin], [Total Revenue], 0)
```

---

## Share Metrics

```dax
Vendor Market Share % =
DIVIDE(
    [Total Revenue],
    CALCULATE(
        [Total Revenue],
        ALL(Vendors)
    ),
    0
)

Category Revenue Share % =
DIVIDE(
    [Total Revenue],
    CALCULATE([Total Revenue], ALL(Categories)),
    0
)

Category Bottles Share % =
DIVIDE(
    [Total Bottles],
    CALCULATE([Total Bottles], ALL(Categories)),
    0
)

Item Revenue Share % =
DIVIDE(
    [Total Revenue],
    CALCULATE([Total Revenue], ALL(Items)),
    0
)

Item Bottles Share % =
DIVIDE(
    [Total Bottles],
    CALCULATE([Total Bottles], ALL(Items)),
    0
)

Bottles per Store Share % =
DIVIDE(
    [Avg Bottles per Store],
    CALCULATE([Total Bottles], ALL(Sales)),
    0
)
```

---

## Ranking

```dax
Category Rank per Vendor =
VAR _vendor = MAX(Vendors[vendor_name])
RETURN
RANKX(
    FILTER(
        ALL(Categories[category_name]),
        CALCULATE([Total Revenue], Vendors[vendor_name] = _vendor) > 0
    ),
    CALCULATE([Total Revenue], Vendors[vendor_name] = _vendor),
    ,
    DESC,
    DENSE
)
```

---

## Pareto Analysis (Cumulative Revenue)

```dax
Cumulative Revenue =
VAR _rank = MAX(Stores[Store Rank Col])
RETURN
CALCULATE(
    [Total Revenue],
    FILTER(
        ALL(Stores),
        Stores[Store Rank Col] <= _rank
    )
)

Cumulative Revenue % =
DIVIDE(
    [Cumulative Revenue],
    CALCULATE([Total Revenue], ALL(Stores)),
    0
)

80% Cutoff Line =
CALCULATE(
    MIN(Stores[Store Rank %]),
    FILTER(
        ALL(Stores),
        [Cumulative Revenue %] >= 0.8
    )
)
```

---

## Time Intelligence

```dax
Revenue 3M Moving Avg =
CALCULATE(
    [Total Revenue],
    DATESINPERIOD(Calendar[Date], LASTDATE(Calendar[Date]), -3, MONTH)
) / 3
```
