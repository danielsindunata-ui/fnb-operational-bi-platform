# Mart Documentation Template

## Purpose

Use this template for documenting PostgreSQL marts that are consumed by Power BI or downstream operational workflows.

Every mart should answer one basic question:

```text
Why does this view exist, what is its grain, and what breaks if it changes?
```

## Template

```md
# mart.object_name

## Purpose

Explain the business purpose of this mart.

## Grain

Define one row.

## Main Consumers

List dashboards, exports, or other marts that use this object.

## Main Sources

List upstream source tables/views.

## Business Logic

Describe calculation logic in business language.

## Important Columns

List important columns and their meaning.

## Known Limitations

List assumptions, risks, or cases where the mart may mislead users.

## Data Quality Notes

Document missing values, negative stock handling, UOM risk, supplier gaps, or other issues.

## Operational Notes

Include refresh dependency, expected row count, performance notes, and whether Power BI depends on this mart.
```

## Documentation Rules

1. Always define the grain.
2. Always name the Power BI consumer.
3. Always document negative stock or missing stock handling.
4. Always document if the mart is decision support rather than automated decision logic.
5. Always document manual inputs and who owns them.
