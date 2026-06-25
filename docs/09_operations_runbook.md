# Operations Runbook

## Purpose

This document explains how the BI platform is expected to run operationally.

It covers refresh cadence, key checks, failure symptoms, and what to inspect first when something looks wrong.

## Platform Components

```text
ERP/API source data
Google Sheets planning inputs
PostgreSQL database
Python ETL scripts
Power BI dashboards
```

## Main Database Layers

```text
raw       = minimally transformed source/API data
clean     = cleaned facts and dimensions
planning  = manual configuration and planning inputs
mart      = Power BI-ready business views
```

## Refresh Pattern

### Daily Refresh

Expected daily refresh pattern:

```text
Daily ETL refresh before operational dashboard review
```

This refresh should update core ERP/API-derived data and downstream marts.

### Ordering Refresh

Ordering may require a more frequent operational refresh window because stores and logistics act on the recommendation during the day.

The ordering refresh may include:

- stock snapshot import
- minimum stock config import
- capacity config import
- logistics mart refresh

### Today-Only Refresh

A today-only refresh can be useful when recent operational data needs to be refreshed without a full historical backfill.

## Refresh Dependencies

### Ordering Dashboard

Main dependencies:

- ERP sales/menu usage
- stock snapshot input
- min stock config
- capacity config
- transfer UOM
- latest purchase price

If ordering looks wrong, check:

1. Latest stock snapshot date
2. Active branch/product coverage
3. Min stock config import
4. Capacity config import
5. Transfer UOM / pack size
6. Recent usage values

### Production Dashboard

Main dependencies:

- ERP sales/menu history
- ERP stock movement
- ERP stock-location
- production demand mapping
- finished goods stock
- warehouse stock

If production looks wrong, check:

1. Latest production refresh timestamp
2. Recent demand windows
3. Stock movement completeness
4. Stock-location completeness
5. Negative stock rows
6. Warehouse stock inclusion
7. Product mapping/classification

### Procurement Dashboard

Main dependencies:

- ERP stock movement
- ERP stock-location
- purchase / receipt history
- supplier master terms
- supplier-product mapping
- item classification
- supply path mapping

If procurement looks wrong, check:

1. Is the item classified as procurement-relevant?
2. Is the item direct or warehouse supplied?
3. Is stock available at the procurement node?
4. Is recent demand being mapped to the correct node?
5. Is supplier lead time available?
6. Is latest supplier history available?

## Common Failure Symptoms

### Power BI refresh is slow despite few rows

Likely cause:

```text
Upstream SQL view scans large historical tables.
```

Check execution plans, repeated view references, missing indexes, and date filters applied too late.

### Dashboard shows stock as negative

Treatment:

- preserve raw negative value for audit
- clamp planning stock to zero for coverage calculations
- check latest stock opname / inventory cycle

### Store/product row is missing

Possible causes:

- product not eligible
- branch inactive
- missing stock snapshot
- missing product mapping
- item excluded by classification
- supply path collapses demand to warehouse node

## Recommended Daily Checks

1. Confirm ETL completed.
2. Confirm latest data date.
3. Confirm Power BI refresh succeeded.
4. Check row counts for critical marts.
5. Check obvious data quality warnings.

## Safety Rule

Do not immediately edit SQL or DAX when a number looks wrong. First trace the issue backward through:

```text
Power BI visual → Power BI model → mart view → planning config / clean fact → raw source → business process
```
