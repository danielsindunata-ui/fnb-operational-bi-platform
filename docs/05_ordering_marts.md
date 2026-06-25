# Ordering Marts

## Purpose

The ordering marts support the Store Ordering Dashboard. This area is the most mature part of the BI platform because the decision boundary is relatively well-defined: stores need replenishment based on recent usage, current stock, minimum stock, capacity, and transfer UOM.

Unlike production and procurement, the ordering dashboard is closer to an automated decision engine. The intended output is a recommended transfer/order quantity that operations and logistics can act on directly.

## Business Context

The ordering system is designed for daily store replenishment planning across active stores.

The core problem is:

```text
Given recent product usage, current store stock, minimum stock targets, store capacity, and transfer UOM,
how much should each store receive?
```

## Main Flow

```text
ERP sales / stock movement data
        ↓
material usage mart
        ↓
usage windows: short-term and medium-term
        ↓
planning stock snapshot + min stock + capacity config
        ↓
final ordering recommendation mart
        ↓
Power BI Ordering Dashboard
```

## Key Objects

| Object | Layer | Purpose |
|---|---|---|
| `mart.material_usage_v1` | mart | Store/product material usage history |
| `mart.ordering_usage_export_v1` | mart | Power BI export for ordering usage |
| `mart.usage_trend_export_v1` | mart | Historical usage trend export |
| `mart.logistics_order_v1` | mart | Final ordering recommendation view |
| `mart.latest_purchase_price_v1` | mart | Latest purchase price by product |
| `planning.fact_stock_snapshot` | planning | Manual/current stock input |
| `planning.min_stock_config` | planning | Minimum stock target by store/product |
| `planning.capacity_config` | planning | Store capacity by branch/group |
| `planning.capacity_item_config` | planning | Product membership for capacity groups |

## Core Logic

At a high level:

1. Calculate recent usage.
2. Compare current stock against minimum stock and demand-based requirement.
3. Apply group capacity rules where relevant.
4. Convert recommended quantity into transfer UOM.
5. Round up based on pack size / transfer unit.
6. Output Power BI-ready rows.

## Usage Windows

The ordering logic uses recent usage windows, commonly combining a short-term and medium-term signal.

Example:

```text
weighted_daily_usage = 0.5 * short_window_usage + 0.5 * medium_window_usage
```

This balances short-term changes with a more stable baseline.

## Rounding Policy

Ordering quantities are rounded up to the transfer pack / UOM where applicable.

| Product Type | Transfer Logic |
|---|---|
| Sachet / packed item | Pack rounding |
| Sauce / batch item | Pack or transfer-UOM rounding |
| Fruit / kg items | Operator may round practically |
| Carton / box items | Integer rounding |

## Known Limitations

- Depends on timely stock snapshot input.
- Planning sheets must be maintained correctly by managers/admin.
- Transfer UOM must be correct in the source system.
- Capacity configuration is manual and may become stale.
- Demand can be distorted by stockouts, machine breakdowns, or unusual operational events.
