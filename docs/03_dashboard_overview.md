# Dashboard Overview

## Purpose

This document summarizes the main Power BI dashboard areas supported by the BI platform.

The dashboards are not all the same type of tool. Some are closer to automated recommendation engines, while others are decision-support dashboards because the business constraints are less stable.

## Dashboard Areas

| Dashboard | Main Purpose | Main Users | Decision Type |
|---|---|---|---|
| Store Ordering Dashboard | Recommend store replenishment quantities | Operations, area manager, logistics | Automated recommendation |
| Production Priority Dashboard | Show finished-goods urgency and coverage risk | Production, PPIC, operations | Decision support |
| Procurement / Raw Material Dashboard | Show raw material coverage, supplier path, and purchase urgency | Purchasing, warehouse, production | Visibility and planning support |
| Audit / Inventory Monitoring | Expose data quality and stock movement issues | Audit, finance, operations | Exception monitoring |

## Store Ordering Dashboard

Core question:

```text
What should each store receive today?
```

Main inputs include recent usage, current store stock, minimum stock, capacity, transfer UOM, and latest price.

Ordering is the most suitable area for automation because the decision constraint is relatively well-defined.

## Production Priority Dashboard

Core question:

```text
Which product should production prioritize, and how much time do we have before it becomes a problem?
```

Production is decision support, not full automation. Production decisions depend on machine capacity, batch size, raw material availability, cold storage, labor, delivery schedule, substitute allocation, and management override.

## Procurement / Raw Material Dashboard

Core question:

```text
What materials are at risk, where is demand coming from, and who can supply them?
```

Procurement is mainly visibility. It should expose missing suppliers, missing stock rows, lead time uncertainty, and warehouse/store demand boundaries.

## Audit / Inventory Monitoring

This area exposes data issues that affect trust in the dashboards, such as negative stock, missing stock rows, purpose-name typos, missing UOM, and incomplete supplier master data.

## Dashboard Adoption Notes

A dashboard should be judged by whether the user can make a better operational decision, not by whether the numbers look technically complete.
