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

## Refresh Pattern

Expected daily refresh pattern:

```text
Daily ETL around the morning operating window
```

Ordering has a more frequent operational refresh window where needed.

A today-only refresh can exist for faster updates when recent operational data needs to be refreshed without a full historical backfill.

## Refresh Dependencies

### Ordering Dashboard

- source sales/menu usage
- stock snapshot input
- min stock config
- capacity config
- transfer UOM
- latest purchase price

### Production Dashboard

- source sales/menu history
- source stock movement
- source stock-location
- production demand mapping
- finished goods stock
- warehouse stock

### Procurement Dashboard

- source stock movement
- source stock-location
- purchase / receipt history
- supplier master terms
- supplier-product mapping
- item classification
- supply path mapping

## Common Failure Symptoms

### Power BI refresh is slow despite few rows

Likely cause:

```text
Upstream SQL view scans large historical tables.
```

Check:

- SQL execution plan
- production demand views
- repeated view references
- missing indexes
- date filters applied too late

### Dashboard shows stock as negative

Treatment:

- preserve raw negative value for audit
- clamp planning stock to zero for coverage calculations
- check latest stock opname cycle

### Store/product row is missing

Possible causes:

- product not eligible
- branch inactive
- missing stock snapshot
- missing product mapping
- item excluded by classification
- supply path collapses demand to warehouse node

## Recommended Daily Checks

```text
1. Confirm ETL completed.
2. Confirm latest data date.
3. Confirm Power BI refresh succeeded.
4. Check row counts for critical marts.
5. Check obvious data quality warnings.
```
