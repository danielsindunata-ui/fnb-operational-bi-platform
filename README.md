# Saladnyoo BI Platform

Operational Business Intelligence platform built for a multi-store F&B business operating Saladnyoo / Joocy outlets.

This repository documents a sanitized case study of the PostgreSQL data warehouse, Python ETL pipelines, Power BI-facing marts, planning logic, and operational dashboards used to support daily decision-making across ordering, production, procurement, inventory visibility, and audit monitoring.

The repository is designed to serve two purposes:

1. **Portfolio case study** — showing end-to-end BI platform design, data modeling, business logic, documentation, and handover discipline.
2. **Public-safe documentation reference** — explaining the system architecture without exposing credentials, raw data, internal infrastructure, or production backup details.

## Project Highlights

- Built a PostgreSQL-based BI warehouse connected to ERP/API data and manual planning inputs.
- Designed schema layers for `raw`, `clean`, `planning`, and `mart` data flows.
- Created Power BI-facing marts for ordering, production, procurement, inventory monitoring, and audit support.
- Documented mart logic, grain, sources, known limitations, data quality risks, and operational notes.
- Added handover documentation covering refresh schedules, backup principles, troubleshooting, credentials, access structure, and database inventory.

## Role

Sole BI / data platform developer responsible for the warehouse design, mart logic, ETL structure, dashboard-facing data models, validation checks, and technical documentation.

The work covered both technical implementation and business process translation: turning operational planning problems into structured data models, dashboard-ready marts, and maintainable handover documentation.

## System Purpose

The BI platform supports operational planning across:

- Store ordering and replenishment recommendation
- Production priority and finished-goods coverage visibility
- Procurement and raw material planning
- Inventory visibility across operational locations
- Audit monitoring and exception checking

It connects ERP/API data, Google Sheets planning inputs, PostgreSQL transformation layers, and Power BI dashboards into one operational intelligence system.

## Main Architecture

```text
             ERP / API Data
          + Planning Sheets
                  │
                  ▼
          Python ETL Pipelines
                  │
                  ▼
          PostgreSQL Warehouse
       raw → clean → planning → mart
                  │
                  ▼
           Power BI Dashboards
                  │
                  ▼
 Operational Planning & Decision Support
```

## Technology Stack

- PostgreSQL
- SQL
- Python ETL pipelines
- Power BI
- REST API integration
- Google Sheets planning inputs
- Git / GitHub documentation
- Operational data modeling

## Main Dashboard Areas

| Area | Purpose | Framing |
|---|---|---|
| Store Ordering Decision Engine | Store replenishment recommendation based on usage, stock, min-stock, and capacity rules | Closest to automated decision engine |
| Production Priority Dashboard | Finished goods urgency and store coverage visibility | Decision support / urgency prioritization |
| Procurement & Raw Material Visibility | Raw material coverage, supplier-path logic, and purchase planning context | Visibility and prioritization |
| Audit & Inventory Monitoring | Data quality, suspicious numbers, stale data, and operational exception monitoring | Control and debugging layer |

## Business Outcomes

The platform was developed to reduce manual planning friction and improve operational visibility across multiple departments.

It provides:

- Centralized operational reporting from ERP/API and planning inputs
- More consistent ordering recommendations across stores
- Production prioritization based on demand, stock, and coverage risk
- Procurement visibility by item, supplier context, warehouse path, and coverage level
- Data quality monitoring for wrong, stale, missing, or suspicious dashboard numbers
- A documented handover structure so the system can be maintained after delivery

## Documentation Index

| Document | Purpose |
|---|---|
| [01 System Overview](docs/01_system_overview.md) | High-level explanation of the platform and dashboard areas |
| [02 Database Architecture](docs/02_database_architecture.md) | PostgreSQL schema layers and design principles |
| [03 Dashboard Overview](docs/03_dashboard_overview.md) | Main dashboards, users, and decision types |
| [04 Mart Documentation Template](docs/04_mart_documentation_template.md) | Standard template for documenting marts |
| [05 Ordering Marts](docs/05_ordering_marts.md) | Ordering dashboard mart logic and planning inputs |
| [06 Production Marts](docs/06_production_marts.md) | Production priority and store coverage marts |
| [07 Procurement Marts](docs/07_procurement_marts.md) | Procurement coverage, supply path, and supplier context |
| [08 Data Quality](docs/08_data_quality.md) | Known data quality issues and current treatments |
| [09 Operations Runbook](docs/09_operations_runbook.md) | Refresh cadence, checks, failure symptoms, and handover rules |
| [10 Backup and Recovery](docs/10_backup_and_recovery.md) | Backup priorities, restore testing, PBIX backup, and handover checklist |
| [11 Troubleshooting Wrong Numbers](docs/11_troubleshooting_wrong_numbers.md) | Debugging guide for wrong, stale, missing, or suspicious dashboard numbers |
| [12 Access and Credentials](docs/12_access_and_credentials.md) | Recommended role-based access structure and credential handover rules |
| [13 Live Database Inventory](docs/13_live_database_inventory.md) | Sanitized PostgreSQL inventory audit, schema/object counts, marts, and dependencies |
| [14 Final Handover Checklist](docs/14_final_handover_checklist.md) | Final go/no-go checklist for backups, credentials, cron, restore testing, and documentation |
| [15 Realistic Access Notes](docs/15_realistic_access_notes.md) | Practical accepted access state and public-safe access notes |

## Confidentiality Note

This repository contains sanitized documentation only. It does not contain production secrets, private credentials, raw operational data, backup artifacts, customer data, employee data, or proprietary exports.
