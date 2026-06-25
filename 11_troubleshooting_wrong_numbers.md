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

Do not immediately edit the mart logic just because the dashboard looks wrong.

## First Question: Is the Number Wrong or Just Unexpected?

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

## Debugging Rule

Never fix a number until you know which layer created the difference.

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
