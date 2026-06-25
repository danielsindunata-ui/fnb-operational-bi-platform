# System Overview

## Purpose

This BI platform supports operational planning for a multi-store F&B business by connecting ERP/API source data, manual planning inputs, PostgreSQL marts, and Power BI dashboards.

The platform is not just a reporting layer. It supports daily operational decisions such as store ordering, production priority, procurement visibility, raw material coverage, inventory audit, and exception monitoring.

## High-Level Flow

```text
ERP/API data + planning sheets
        ↓
Python ETL pipelines
        ↓
PostgreSQL database
        ↓
raw / clean / planning / mart schemas
        ↓
Power BI dashboards
        ↓
Operations / production / purchasing decisions
```

## Main Source Systems

| Source | Purpose |
|---|---|
| ERP/API | Sales, stock movement, stock location, product, supplier, purchasing, and inventory data |
| Google Sheets | Manual planning configuration such as stock snapshots, min stock, capacity, supplier terms, and operating assumptions |
| PostgreSQL | Central data warehouse and calculation layer |
| Power BI | User-facing dashboards |

## Main Dashboard Areas

| Dashboard Area | Purpose | Decision Type |
|---|---|---|
| Store Ordering | Recommend store replenishment quantities | More automated decision engine |
| Production Priority | Show finished-goods urgency and store coverage | Decision support |
| Procurement / Raw Material | Show raw material coverage, supplier path, and purchase urgency | Visibility and planning support |
| Audit / Inventory Monitoring | Detect unusual stock movement, negative stock, typo issues, and data quality risks | Control and exception monitoring |

## Design Principle

The platform separates source extraction, data cleaning, planning assumptions, and Power BI-facing marts.

```text
raw       = source/API data as close to original as practical
clean     = standardized facts and dimensions
planning  = manual business assumptions and configuration
mart      = dashboard-ready business views
```

Ordering is the most mature dashboard because the constraint is relatively well-defined: current stock, demand, min stock, capacity, and transfer UOM.

Production and procurement are treated more as decision support because they depend on real-world constraints such as machine capacity, batch size, storage, supplier behavior, lead time uncertainty, and management override.
