# Database Architecture

## Overview

The PostgreSQL database is the calculation backbone for the BI platform. Data is extracted from source systems and planning sheets, standardized into clean tables, enriched with planning configuration, and exposed to Power BI through mart views.

## Layered Architecture

```text
Source systems
  ├── ERP/API data
  └── Google Sheets
        ↓
raw schema
        ↓
clean schema
        ↓
planning schema
        ↓
mart schema
        ↓
Power BI
```

## Schema Responsibilities

| Schema | Responsibility | Example Content |
|---|---|---|
| raw | Store source data with minimal transformation | API responses, staging tables, raw extracts |
| clean | Standardized facts and dimensions | sales menu, stock movement, product, location, supplier |
| planning | Manual configuration and business assumptions | stock snapshot, min stock, capacity, supplier terms |
| mart | Power BI-facing business views | ordering, production priority, procurement coverage |

## Key Design Rules

### 1. Keep Power BI simple

Complex calculations should be pushed into PostgreSQL where they can be tested, indexed, and reused.

### 2. Preserve raw values where useful

For issues such as negative stock, the raw value should be preserved for audit/debugging, while planning logic may use a safer adjusted value.

### 3. Do not fabricate operational truth

If a source system has missing stock rows, missing suppliers, or missing lead time, the mart should expose the problem rather than silently inventing data.

### 4. Use mart versioning

Important business views should use versioned names such as `_v1`, `_v2_test`, or similar naming so changes can be tested without breaking Power BI immediately.

## Known Architectural Risks

| Risk | Description | Mitigation |
|---|---|---|
| Source process inconsistency | Users may not follow the ideal ERP process | Document assumptions and use validation layers |
| Negative stock | ERP can show negative stock that may not equal physical stock | Preserve raw, clamp to zero for planning where appropriate |
| Manual configs | Google Sheets inputs can be incomplete or stale | Add validation and reject tables where possible |
| Heavy views | Production marts can be slow due to large sales and stock movement scans | Add indexes/materialized views where needed |
| Adoption gap | Some dashboards may be built correctly but not used consistently | Document business purpose and owner clearly |
