# Production Marts

## Purpose

The production marts support the Production Priority Dashboard. This dashboard helps production, PPIC, and operations understand which finished goods are most urgent based on recent demand, store coverage, warehouse stock, and operational risk.

Unlike the Ordering Dashboard, the Production Dashboard is not intended to be a fully automated decision engine. Production has many moving parts that cannot be fully captured in one mart, such as:

- machine availability
- batch size
- labor availability
- cold storage space
- packaging constraints
- substitute allocation
- area delivery schedule
- manager override

The correct framing is:

```text
The dashboard does not tell production exactly what to do.
It tells production how much time they have before the problem becomes critical.
```

## Main Flow

```text
ERP sales / stock movement / stock-location data
        ↓
production demand and stock calculations
        ↓
store-level coverage
        ↓
product-level priority ranking
        ↓
Power BI Production Priority Dashboard
```

## Key Tables and Views

| Object | Layer | Purpose |
|---|---|---|
| `mart.production_priority_v1` | mart | Product-level production priority ranking |
| `mart.production_store_coverage_v1` | mart | Store/product coverage detail |
| `mart.production_stock_balance_v1` | mart | Production stock balance by product/location |
| `mart.raw_material_inventory_v1` | mart | Raw material inventory visibility |
| `mart.production_demand_recent_windows_v1` | mart | Recent production demand windows |
| `mart.production_demand_combined_daily_v1` | mart | Combined daily production demand |
| `mart.production_demand_reconciliation_v1` | mart | Demand reconciliation/debugging |

## Important Business Rule

Product-level priority should consider total available stock:

```text
total_stock_qty = store_stock_qty + warehouse_stock_qty
```

Store coverage remains based on store stock because store-level risk is still operationally relevant.

## Negative Stock Treatment

```text
raw negative stock is preserved for audit
coverage stock is clamped to 0
```

Negative stock does not necessarily mean physical stock is truly negative, but for planning purposes it should be treated as unavailable.

## Performance Notes

Known performance issue:

```text
production_store_coverage_v1 can be slow despite having few output rows.
```

Reason: the expensive part is not the final row count. The expensive part is the historical scan needed to calculate recent production demand and coverage.

Potential fixes:

- add supporting indexes on sales/menu date and menu/product keys
- add supporting indexes on stock movement date, transaction type, and product
- materialize recent demand windows
- avoid recalculating the same heavy views multiple times
