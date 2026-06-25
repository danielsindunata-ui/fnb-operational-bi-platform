# F&B Operational BI Platform

A sanitized case study of an operational Business Intelligence platform built for a multi-store F&B business.

This repository documents the architecture, data warehouse structure, ETL logic, Power BI-facing marts, planning rules, and operational dashboard design used to support daily decision-making across ordering, production, procurement, inventory visibility, and audit monitoring.

The implementation is based on a real project, but company-specific information, credentials, raw data, internal infrastructure details, and proprietary exports have been removed or anonymized.

## Project Highlights

- Designed a PostgreSQL-based BI warehouse connected to ERP/API data and manual planning inputs.
- Built layered data models using `raw`, `clean`, `planning`, and `mart` schemas.
- Created Power BI-facing marts for ordering, production, procurement, inventory monitoring, and audit support.
- Translated operational planning problems into structured SQL models and dashboard-ready business logic.
- Documented mart logic, grain, source dependencies, known limitations, data quality risks, troubleshooting rules, and handover procedures.

## Role

Sole BI / data platform developer responsible for the warehouse design, mart logic, ETL structure, dashboard-facing data models, validation checks, and technical documentation.

The work covered both technical implementation and business process translation: turning messy operational planning problems into structured data models, dashboard-ready marts, and maintainable handover documentation.

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

## Repository Structure

```text
.
├── README.md
├── docs/
│   ├── 01_system_overview.md
│   ├── 02_database_architecture.md
│   ├── 03_dashboard_overview.md
│   ├── 04_mart_documentation_template.md
│   ├── 05_ordering_marts.md
│   ├── 06_production_marts.md
│   ├── 07_procurement_marts.md
│   ├── 08_data_quality.md
│   ├── 09_operations_runbook.md
│   ├── 10_backup_and_recovery.md
│   ├── 11_troubleshooting_wrong_numbers.md
│   ├── 12_access_and_credentials.md
│   ├── 13_live_database_inventory.md
│   ├── 14_final_handover_checklist.md
│   └── 15_realistic_access_notes.md
└── .gitignore
```

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
