# Data Quality Notes

## Purpose

This document records known data quality issues, current treatments, and business interpretation rules.

The goal is not to blame the source system or users. The goal is to make dashboard assumptions explicit so future maintainers understand why the marts behave the way they do.

## 1. Negative Stock

Negative stock can appear in stock-location and stock movement data.

It may happen because:

- stock movement timing is wrong
- stock opname has not reset the item yet
- transfers/adjustments were entered late
- system stock and physical stock are temporarily out of sync
- inventory is reset during a stock opname cycle

Current treatment:

```text
Raw value: preserve for audit/debugging
Planning value: clamp to 0
```

## 2. Supplier Lead Time and MOQ

Supplier lead time and MOQ are not fully reliable yet.

Known problems include:

- MOQ values defaulted to 1
- lead time values defaulted to 1
- non-numeric MOQ entries
- non-numeric lead time entries
- supplier-product mapping incomplete
- supplier behavior may differ by item

When multiple suppliers exist and lead time is uncertain, use a conservative rule:

```text
Prefer the longest reasonable lead time.
```

## 3. Product Classification Risk

Item classification may not fully represent business reality.

If classification is wrong, dashboards may:

- exclude items that should be procured
- include self-produced items in procurement
- assign wrong supply path
- show demand at the wrong location
- hide downstream store demand inside warehouse rows

## 4. Demand Distortion

Recent demand can be distorted by operational events.

Examples:

- item stockout
- machine breakdown
- production shortage
- substitute allocation
- store closure
- promotion spike
- unusual delivery schedule

A drop in demand does not always mean true customer demand dropped.

It may mean:

```text
The product was unavailable, so sales/usage could not happen.
```

## 5. Stock Snapshot Freshness

Some planning logic depends on Google Sheets stock snapshots or daily inventory input.

If stock input is late or stale, dashboard recommendations can be technically correct but operationally wrong.

Power BI should expose freshness indicators where possible:

- latest stock snapshot date
- latest refresh timestamp
- missing stock rows
- negative stock rows
- stale input warning
