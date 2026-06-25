# Troubleshooting Wrong Numbers

## Purpose

This document explains what to check when dashboard numbers look wrong.

The goal is to avoid random fixes. Most dashboard issues should be debugged by moving backward through the data chain:

```text
Power BI visual
    ↓
Power BI table / measure / filter
    ↓
mart view
    ↓
planning config or clean fact
    ↓
raw source table
    ↓
ERP / Google Sheets source
```

Do not immediately edit mart logic just because the dashboard looks wrong.

## First Question: Is the Number Wrong or Just Unexpected?

Before debugging, identify the expected number and who defines it.

Ask:

- Which dashboard page is wrong?
- Which visual is wrong?
- Which product, branch, location, or date is wrong?
- What number did the user expect?
- Where did the expected number come from?
- Is the user comparing against ERP, Google Sheets, manual count, or memory?

Many issues are not calculation bugs. They are usually caused by:

- different date filters
- stale Power BI refresh
- stale source extraction
- different stock location
- negative stock handling
- unit conversion
- hidden visual filters
- business process timing

## General Debugging Order

1. Confirm Power BI refresh time.
2. Check page, visual, and slicer filters.
3. Check whether the correct mart is being used.
4. Query the mart directly in PostgreSQL.
5. Compare mart row count and key filters.
6. Check upstream clean/raw source data.
7. Check manual planning inputs.
8. Check business logic assumptions.
9. Only then change SQL or DAX.

## Common Symptom: Dashboard Is Blank

Possible causes:

| Cause | Check |
|---|---|
| Power BI refresh failed | Refresh history / error message |
| Database connection failed | Credential, network, server status |
| Mart returned zero rows | `select count(*) from mart_name;` |
| Date filter excludes all rows | Clear slicers / check DimDate |
| Relationship issue | Check Power BI model relationships |
| Source table not refreshed | Check ETL logs and latest dates |

## Common Symptom: Numbers Did Not Update Today

Check the latest available source dates and planning input dates.

Possible causes:

- daily job failed
- ERP/API extraction failed
- Google Sheet import failed
- Power BI has not refreshed after database refresh
- source data was not input by users yet
- business process timing changed

## Common Symptom: Stock Looks Wrong

Ask which stock definition is expected:

- store stock
- warehouse stock
- total stock
- current stock after clamping negative values
- raw ERP stock
- Google Sheets snapshot stock

These are not always the same.

Current planning rule:

```text
Raw negative stock is preserved for audit.
Planning and coverage logic treats negative stock as 0.
```

## Common Symptom: Ordering Recommendation Looks Too High

Check in this order:

1. Is current stock missing or stale?
2. Is min stock too high?
3. Is recent usage inflated?
4. Is capacity allocation active?
5. Is UOM conversion correct?
6. Is pack-size rounding causing a jump?
7. Is the product included in the correct capacity group?

## Common Symptom: Production Priority Looks Wrong

Production is not a pure automation engine. It is decision support.

Check:

1. Is store demand correct?
2. Is warehouse stock included or excluded as intended?
3. Is store coverage using store stock only?
4. Is product-level priority using total stock?
5. Are negative stocks clamped to 0?
6. Is the product mapping correct?
7. Is production demand source movement data or fallback logic?
8. Did a stockout distort recent usage?

## Common Symptom: Procurement Item Is Missing

Check:

- item has purchase or receipt history
- item is classified as procurement item, not self-produced output
- item has supply path mapping
- item exists in stock-location source
- demand is mapped to the correct terminal item
- warehouse/direct path is correct
- location boundary is correct

## Debugging Rule

Never fix a number until you know which layer created the difference.

Use this chain:

```text
Visual filter
→ DAX measure
→ Power BI table
→ mart view
→ planning config
→ clean fact
→ raw source
→ business process
```

If the issue cannot be traced to a layer, do not patch the dashboard blindly.
