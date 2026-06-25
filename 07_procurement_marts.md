# Procurement Marts

## Purpose

The procurement marts support purchasing and raw material visibility.

The goal is not to fully automate purchasing decisions yet. The goal is to make procurement risk visible:

```text
What do we have?
What do we need?
Where is the demand coming from?
Who can supply it?
How many days of coverage remain?
```

This area is still evolving because supplier master data, lead time, MOQ, and warehouse/store supply paths are not fully standardized.

## Business Context

Procurement is harder to automate than store ordering because there are more unstable variables:

- supplier-specific lead time
- supplier-specific MOQ
- incomplete supplier master data
- inconsistent purchasing process usage
- warehouse vs direct-to-store supply paths
- item classification ambiguity
- negative stock
- production vs purchased item boundary

The correct framing is:

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

## Key Tables and Views

| Object | Layer | Purpose |
|---|---|---|
| `mart.procurement_coverage_v1` | mart | Material coverage by item/location |
| `mart.procurement_actionable_ranking_v1_test` | mart | Actionable procurement ranking |
| `mart.procurement_supply_path_v1` | mart | Location/product supply path classification |
| `mart.procurement_item_classification_v1` | mart | Item procurement eligibility/classification |
| `planning.procurement_supplier_terms` | planning | Supplier lead time/MOQ terms |
| `planning.procurement_supplier_product` | planning | Product-supplier mapping |
| `mart.latest_purchase_price_v1` | mart | Latest purchase price reference |

## Known Limitations

Coverage is only as good as:

- stock-location completeness
- product classification accuracy
- demand mapping accuracy
- supplier master completeness

## Negative Stock Treatment

```text
Preserve raw negative stock for audit.
Clamp planning stock to 0 for coverage/action logic.
```

Negative stock may not reflect physical reality because it can be reset during stock opname cycles. However, for planning, negative stock should not be treated as available stock.
