# Procurement Marts

## Purpose

The procurement marts support purchasing and raw material visibility.

The goal is not to fully automate purchasing decisions. The goal is to make procurement risk visible:

```text
What do we have?
What do we need?
Where is the demand coming from?
Who can supply it?
How many days of coverage remain?
```

This area is harder to automate because supplier master data, lead time, MOQ, and warehouse/store supply paths are not always standardized.

## Business Context

Procurement is harder to automate than store ordering because there are more unstable variables:

- supplier-specific lead time
- supplier-specific MOQ
- incomplete supplier master data
- inconsistent purchasing workflows
- warehouse vs direct-to-store supply paths
- item classification ambiguity
- negative stock
- production vs purchased item boundary

Correct framing:

```text
Procurement dashboard = visibility and prioritization tool
not a final automated purchase order engine
```

## Main Flow

```text
ERP stock movement / stock-location / purchase history
        ↓
clean facts and product history
        ↓
procurement item classification
        ↓
supply path mapping
        ↓
coverage and ranking marts
        ↓
Power BI Procurement / Raw Material Dashboard
```

## Key Objects

| Object | Layer | Purpose |
|---|---|---|
| `mart.procurement_coverage_v1` | mart | Material coverage by item/location |
| `mart.procurement_actionable_ranking_v1_test` | mart | Actionable procurement ranking |
| `mart.procurement_supply_path_v1` | mart | Location/product supply path classification |
| `mart.procurement_item_classification_v1` | mart | Item procurement eligibility/classification |
| `mart.procurement_intermediate_blocked_demand_v1` | mart | Blocks intermediate/self-produced demand where needed |
| `planning.procurement_supplier_terms` | planning | Supplier lead time/MOQ terms |
| `planning.procurement_supplier_product` | planning | Product-supplier mapping |
| `mart.latest_purchase_price_v1` | mart | Latest purchase price reference |

## Coverage Logic

Target grain is generally:

```text
planning_date + location + product
```

Location is important because procurement visibility depends on where stock and demand exist.

Business question:

```text
Given current stock and recent usage, how many days of coverage remain for each material at each relevant location?
```

## Supply Path Logic

Typical supply paths:

```text
DIRECT
WAREHOUSE
```

Procurement logic needs to know whether demand should trigger direct purchasing for that location or warehouse-level replenishment that covers downstream demand.

## Supplier Master Risk

Supplier master data should be treated as directional, not fully reliable.

Known issues can include:

- MOQ defaults
- lead time defaults
- non-numeric MOQ values
- non-numeric lead time values
- incomplete supplier-product mapping

Where multiple suppliers exist and lead time is uncertain, a conservative approach is preferred:

```text
Use the longest reasonable lead time for planning risk.
```

## Negative Stock Treatment

```text
Preserve raw negative stock for audit.
Clamp planning stock to 0 for coverage/action logic.
```

Negative stock may not reflect physical reality, but for planning, it should not be treated as available stock.
