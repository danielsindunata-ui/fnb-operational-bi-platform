# Realistic Access Notes

## Purpose

This document records the practical access and handover stance in a sanitized, public-safe format.

The goal is not to pretend the system has perfect role separation. The goal is to make sure working access paths are understood privately, not accidentally broken, and not over-engineered during handover.

No credential values, live usernames, account names, internal paths, hostnames, IP addresses, backup filenames, or environment-file details should be stored in this public repository.

## Practical Rule

Do not break the working production access just to make the access model cleaner.

For handover, the safer position is:

```text
working but imperfect > theoretically cleaner but untested
```

## Power BI

Power BI should ideally use a read-only database role.

However, changing Power BI credentials can break scheduled refresh or local PBIX refresh if not tested carefully.

## ERP/API ETL Credential

API extraction credentials should remain outside GitHub.

The important control is behavior, not exposing account names:

- extraction scripts should stay GET/read-oriented;
- auth/login remains the limited exception;
- do not loosen guardrails to allow write/update/delete API behavior;
- do not commit env files, tokens, passwords, JWTs, or account names to GitHub.

## Database ETL Path

Scheduled jobs depend on the server environment and database credential path configured outside this repository.

Do not assume the ERP/API credential is the same thing as the PostgreSQL database credential. They are separate access layers:

```text
ERP/API credential = pulls source data from ERP/API
PostgreSQL access = writes/queries the local BI database
```

## Backup / Restore Reality

The production handover should maintain a full data-bearing backup outside the repository.

Public documentation may describe the backup principle, but should not expose:

- dump filenames;
- dump paths;
- checksums;
- internal backup folders;
- backup storage account names;
- database names if they identify the production environment.

## Future Clean-Up, If Someone Owns It

The future clean version would separate:

```text
database superadmin / break-glass role = emergency admin only
backup operator                         = backup/restore role
Power BI reader                         = dashboard read-only role
ETL service role                        = PostgreSQL ETL load role
ERP/API reader                          = source-system extraction role
```
