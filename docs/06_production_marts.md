# Production Marts

## Purpose

The production marts support the Production Priority Dashboard. This dashboard helps production, planning, and operations understand which finished goods are most urgent based on recent demand, store coverage, warehouse stock, and operational risk.

Unlike the Ordering Dashboard, the Production Dashboard is not intended to be a fully automated decision engine.

The correct framing is:

```text
The dashboard does not tell production exactly what to do.
It tells production how much time they have before the problem becomes critical.
```

## Business Context

The production dashboard was designed to answer:

```text
Which finished goods are at risk of running out, where, and how urgent is the risk?
```

It gives production and operations a shared view of demand and coverage so they can coordinate earlier.

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

## Key Objects

| Object | Layer | Purpose |
|---|---|---|
| `mart.production_priority_v1` | mart | Product-level production priority ranking |
| `mart.production_store_coverage_v1` | mart | Store/product coverage detail |
| `mart.production_stock_balance_v1` | mart | Production stock balance by product/location |
| `mart.raw_material_inventory_v1` | mart | Raw material inventory visibility |
| `mart.production_demand_recent_windows_v1` | mart | Recent production demand windows |
| `mart.production_demand_combined_daily_v1` | mart | Combined daily production demand |
| `mart.production_demand_reconciliation_v1` | mart | Demand reconciliation/debugging |

## Production Priority Logic

The mart combines:

- recent demand
- current store stock
- warehouse stock
- coverage days
- number of stores at risk
- product visibility rules

The ranking is intended to surface which items need attention first.

## Store Coverage Logic

Store coverage remains based on store stock because store-level risk is still operationally relevant.

Typical concepts include:

- current store stock
- recent daily usage
- coverage days
- stockout / low coverage risk
- area/store visibility

## Negative Stock Treatment

Negative stock can exist in ERP data.

Current planning treatment:

```text
raw negative stock is preserved for audit
coverage stock is clamped to 0
```

Reason: negative stock does not necessarily mean physical stock is truly negative, but for planning purposes it should be treated as unavailable.

## Demand Hierarchy

Production demand should prefer operational movement data where available.

Recommended hierarchy:

```text
1. POS / stock movement demand
2. Menu/BOM fallback demand
3. Reconciliation/debugging layer
```

## Performance Notes

Some production marts can be slow despite having few output rows. The expensive part is often the historical scan needed to calculate recent demand and coverage.

Potential fixes:

- add supporting indexes on sales/menu date and product keys
- add supporting indexes on stock movement date, transaction type, and product
- materialize recent demand windows
- avoid recalculating the same heavy views multiple times
