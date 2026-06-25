# Live Database Inventory

## Purpose

This document records a sanitized PostgreSQL inventory audit performed for handover.

The audit was read-only. No schema changes, table changes, materialized view refreshes, destructive SQL, credential changes, revokes, or downgrades were performed.

Production hostnames, internal paths, command outputs, backup filenames, checksums, and live credential names have been removed from this public-safe version.

## Audit Run

| Item | Value |
|---|---|
| Audit date | 2026-06-24 |
| Timezone | Asia/Jakarta / WIB |
| Database | Production BI PostgreSQL database |
| Script used | Read-only database inventory SQL script |
| Output location | Stored privately outside this public repository |

## Schema Inventory

| Schema | Tables | Views | Materialized Views | Notes |
|---|---:|---:|---:|---|
| `analytics` | 1 | 0 | 0 | Supporting analytics table layer |
| `audit` | 2 | 0 | 0 | Audit/control data |
| `clean` | 22 | 0 | 0 | Main cleaned fact and dimension-like tables |
| `control` | 5 | 0 | 0 | Manual/current control inputs |
| `dim` | 0 | 6 | 0 | Dimension views |
| `etl` | 0 | 1 | 0 | ETL helper view |
| `mart` | 0 | 68 | 3 | Power BI-facing mart layer |
| `planning` | 23 | 0 | 0 | Google Sheets/manual planning inputs and run logs |
| `public` | 0 | 0 | 0 | Empty at audit time |
| `raw` | 3 | 0 | 0 | Raw source/API tables |

## Largest Objects

| Rank | Object | Type | Estimated Rows | Size |
|---:|---|---|---:|---:|
| 1 | `clean.fact_stock_movement` | table | ~2.8M | ~1.9 GB |
| 2 | `clean.fact_sales_menu` | table | ~2.0M | ~863 MB |
| 3 | `clean.fact_sales_header` | table | ~901K | ~247 MB |
| 4 | `clean.fact_sales_payment` | table | ~746K | ~169 MB |
| 5 | `clean.fact_simple_purchase_detail` | table | ~25K | ~51 MB |
| 6 | `planning.audit_patrol_log` | table | ~49K | ~25 MB |
| 7 | `planning.audit_sheet_import_reject` | table | ~17K | ~9 MB |
| 8 | `clean.fact_stock_opname_detail` | table | ~13K | ~4 MB |
| 9 | `planning.audit_cancel_log` | table | ~6K | ~4 MB |
| 10 | `clean.fact_stock_location` | table | ~8K | ~4 MB |

The size profile is dominated by stock movement and sales facts. Future performance work should start with the largest sales and stock movement fact tables and any views that repeatedly scan them.

## Mart Objects

The live `mart` schema contained 71 objects: 68 views and 3 materialized views.

Main mart groups observed:

| Group | Representative objects |
|---|---|
| Ordering | `basic_order_need_v1`, `logistics_order_v1`, `ordering_usage_export_v1`, `usage_trend_export_v1` |
| Production | `production_priority_v1`, `production_store_coverage_v1`, `production_urgency_v1`, `production_stock_balance_v1`, `production_demand_recent_windows_v1` |
| Procurement | `procurement_actionable_ranking_v1_test`, `procurement_coverage_v1`, `procurement_coverage_cache_v1`, `procurement_supply_path_v1`, `procurement_usage_trend_v1` |
| Inventory / raw material | `raw_material_inventory_v1`, `raw_material_inventory_detail_v1`, `current_stock_unified_v1` |
| Audit | `audit_cancel_monitor_v1`, `audit_finding_v1`, `audit_patrol_v1`, `audit_stock_opname_v1`, `audit_transaction_count_v1` |
| Sales / BOM / costing | `sales_menu_v1`, `sales_header_v1`, `bom_cost_summary_v1`, `product_costing_classification_v1` |

## View Dependency Notes

High-dependency views are higher-risk change points because one edit can alter several dashboard outputs.

Examples of dependency-heavy areas:

- ordering usage export
- procurement actionable ranking
- procurement coverage computation
- branch dimension logic
- audit item journal logic
- material usage price mapping
- production demand combination
- production store coverage

## Handover-Worthy Objects

These are not necessarily wrong, but they should be reviewed before the platform is considered fully clean:

| Object / Pattern | Reason to Review |
|---|---|
| `raw.test_connection` | Looks like a connectivity/probe table. Confirm whether it is still needed. |
| `_test` suffix on Power BI-facing marts | Confirm whether this is production-intended naming. |
| Empty `public` schema | No issue, but useful to know. |
| Large stock movement fact table | Likely the first place to check for slow refreshes or missing indexes. |

## Safety Notes

- The inventory audit was metadata/read-only.
- Row counts are PostgreSQL estimates, not exact `count(*)` results.
- Normal views do not store data.
- No materialized views were refreshed during this audit.
- No credentials were changed during this audit.
- No full data-bearing PostgreSQL dump, checksum file, or restore-list file was committed to GitHub.
