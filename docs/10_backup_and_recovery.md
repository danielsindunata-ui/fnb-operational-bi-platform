# Backup and Recovery

## Purpose

This document explains backup and recovery principles for the BI platform in a sanitized, public-safe format.

The goal is not to publish production recovery details. The goal is to show that backup, restore, and handover risk were considered as part of the system design.

This repository must not contain production dump files, backup filenames, internal backup paths, checksums, credentials, hostnames, IP addresses, or raw operational exports.

## Backup Priorities

| Priority | Asset | Reason |
|---|---|---|
| Critical | PostgreSQL database | Contains raw, clean, planning, and mart data |
| Critical | ETL scripts | Controls extraction, transformation, and refresh logic |
| Critical | Power BI files | Contains report layout, measures, relationships, and visuals |
| High | Google Sheets planning inputs | Contains editable business configuration |
| High | Environment variables / credentials inventory | Needed for recovery, but secrets must not be committed |
| Medium | Logs | Useful for debugging recent failures |
| Medium | Documentation | Explains how the system fits together |

GitHub should contain documentation, code, SQL scripts, and read-only audit scripts. It must not contain PostgreSQL dumps, `.env` files, passwords, API tokens, service account keys, raw sales exports, supplier/customer-sensitive extracts, or production backup metadata.

## Recommended Backup Design

A practical backup design should include:

| Copy | Location Type | Purpose |
|---|---|---|
| Primary backup | Server-local backup directory | Fast local restore/debugging |
| Secondary backup | Company-controlled cloud/shared storage | Survives server failure |
| Optional cold copy | Owner-controlled archive | Extra protection before handover |

The exact paths and storage account names should be documented privately, not in GitHub.

## Handover Backup Standard

A practical handover backup should confirm:

| Item | Expected Result |
|---|---|
| Full custom-format dump with data | Completed by authorized operator |
| SHA256 checksum | Generated and stored with the dump |
| Restore-list verification | `pg_restore --list` can read the archive |
| Off-server copy | Backup copied outside the production server |
| Full restore test | Ideal, but may be deferred if risk is accepted and documented privately |
| GitHub safety | Dumps, checksum files, restore-list files, `.env` files, credentials, and secrets are not committed |

## Restore Test

A backup is not fully proven until it has been test-restored somewhere safe.

Restore into a test database, never directly into production:

```bash
createdb bi_platform_restore_test

pg_restore \
  --dbname=bi_platform_restore_test \
  --verbose \
  bi_platform_postgres_YYYYMMDD_HHMM.dump
```

After restore, check schema counts and critical mart row counts.

## Power BI Backup

Back up all PBIX files used by operations.

Power BI files often contain DAX measures, relationships, slicers, hidden columns, visual filters, page-level filters, and query transformations that are not visible from PostgreSQL alone.

## Google Sheets Backup

Export or copy the planning input sheets used by the system.

Important sheet groups include stock snapshot, minimum stock, capacity configuration, logistics unit configuration, supplier terms, supplier-product mapping, and audit reference inputs.

## Credentials Inventory

Maintain a private note outside GitHub that lists where credentials are stored and who owns them.

The documentation may mention that credentials exist, but should not contain the actual secrets or production account names.
