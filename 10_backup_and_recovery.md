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

Restore into a test database, never directly into production.

If a full restore test is deferred, the documentation should explicitly say so and should not claim full restore has been proven.

## Important Principle

The most dangerous failure is not only the database going down.

The most dangerous failure is numbers changing silently and nobody knowing whether the issue came from:

- source-system data
- ETL refresh
- Google Sheets input
- mart logic
- Power BI model logic
- user filters
- stale refresh
