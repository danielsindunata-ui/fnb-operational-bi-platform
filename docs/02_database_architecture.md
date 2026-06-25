# Database Architecture

## Overview

The PostgreSQL database is the calculation backbone of the BI platform. Data is extracted from ERP/API sources and planning sheets, standardized into clean tables, enriched with planning configuration, and exposed to Power BI through mart views.

## Layered Architecture

```text
Source systems
  ├── ERP/API
  └── Planning sheets
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
| `raw` | Store source data with minimal transformation | API responses, staging tables, raw extracts |
| `clean` | Standardized facts and dimensions | sales, stock movement, product, location, supplier |
| `planning` | Manual configuration and business assumptions | stock snapshot, min stock, capacity, supplier terms |
| `mart` | Power BI-facing business views | ordering, production priority, procurement coverage |

## Key Design Rules

### 1. Keep Power BI simple

Complex calculations are pushed into PostgreSQL where they can be tested, versioned, indexed, and reused.

### 2. Preserve raw values where useful

For issues such as negative stock, the raw value should be preserved for audit/debugging while planning logic may use a safer adjusted value.

### 3. Do not fabricate operational truth

If a source system has missing stock rows, missing suppliers, or missing lead time, the mart should expose the problem rather than silently inventing data.

### 4. Use mart versioning

Important business views should use versioned names such as `_v1` or `_v2_test` so changes can be tested before replacing Power BI-facing contracts.

## Known Architectural Risks

| Risk | Description | Mitigation |
|---|---|---|
| Source-process inconsistency | Business users may use workflows inconsistently, making lead time or stock logic difficult to infer | Document assumptions and use validation checks |
| Negative stock | System stock can show negative values that may not equal physical stock | Preserve raw, clamp to zero for planning where appropriate |
| Manual configs | Planning sheets can be incomplete or stale | Add validation and reject tables where possible |
| Heavy views | Some marts can be slow because they scan large historical tables | Add indexes, materialized views, or recent-window tables |
| Adoption gap | Dashboards may be correct but not consistently used | Document business purpose and owner clearly |
