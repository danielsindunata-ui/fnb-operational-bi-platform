# Data Quality Notes

## Purpose

This document records known data quality issues, current treatments, and business interpretation rules.

The goal is not to blame the source system or users. The goal is to make dashboard assumptions explicit so future maintainers understand why the marts behave the way they do.

## 1. Negative Stock

### Issue

Negative stock can appear in ERP stock-location and stock movement data.

### Business Interpretation

Negative stock does not always mean physical stock is truly negative. It may happen because:

- stock movement timing is wrong
- inventory adjustments were entered late
- transfers were delayed
- system stock and physical stock are temporarily out of sync
- inventory is reset during a stock opname cycle

### Current Treatment

```text
Raw value: preserve for audit/debugging
Planning value: clamp to 0
```

For planning purposes, negative stock should not be treated as available inventory.

## 2. Source-System Typo / Classification Issues

Source systems can contain inconsistent labels, typo values, or incomplete item classification.

Impact:

- audit categories can split incorrectly
- product classification can become unreliable
- dashboards may exclude or include the wrong items

Treatment:

- fix the source template where possible
- map historical values where necessary
- document known exceptions

## 3. Supplier Lead Time and MOQ

Supplier lead time and MOQ are not always fully reliable.

Known problems can include:

- MOQ defaults
- lead time defaults
- non-numeric MOQ entries
- non-numeric lead time entries
- supplier-product mapping gaps
- supplier behavior differing by item

Treatment:

```text
Supplier master data should be treated as a planning estimate, not contractual truth.
```

## 4. Product Classification Risk

Some products may be ambiguous between:

- purchased item
- production output
- intermediate production item
- store-use item
- warehouse-managed item
- direct-supplied item

If classification is wrong, dashboards may:

- exclude items that should be procured
- include self-produced items in procurement
- assign wrong supply path
- show demand at the wrong location
- hide downstream store demand inside warehouse rows

## 5. Demand Distortion

Recent demand can be distorted by operational events:

- item stockout
- machine breakdown
- production shortage
- substitute allocation
- store closure
- promotion spike
- unusual delivery schedule

A drop in demand does not always mean true customer demand dropped. It may mean the product was unavailable, so sales/usage could not happen.

Treatment:

- use short and medium recent windows where possible
- compare absolute quantities, not only percentages
- interpret demand with operational context

## 6. Stock Snapshot Freshness

Some planning logic depends on manual or semi-manual stock snapshots.

Risk:

```text
If stock input is late or stale, dashboard recommendations can be technically correct but operationally wrong.
```

Power BI should expose freshness indicators where possible:

- latest stock snapshot date
- latest refresh timestamp
- missing stock rows
- negative stock rows
- stale input warning
