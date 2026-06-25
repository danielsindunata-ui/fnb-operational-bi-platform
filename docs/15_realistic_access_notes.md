# Realistic Access Notes

## Purpose

This document records the practical access and handover stance in a sanitized, public-safe format.

The goal is not to pretend the system has perfect role separation. The goal is to make sure working access paths are understood privately, not accidentally broken, and not over-engineered during handover.

No credential values, live usernames, account names, internal paths, hostnames, IP addresses, backup filenames, or environment-file details should be stored in this public repository.

## Current Confirmed Access Reality

The production system had practical access paths for:

| Area | Public-Safe Description | Practical Decision |
|---|---|---|
| Power BI PostgreSQL connection | Dashboard-facing database access | Keep stable unless someone owns and tests a read-only migration. |
| ETL PostgreSQL write/query path | Scheduled jobs run through the production server environment | Do not change without testing cron/ETL refresh. |
| ERP/API extraction | Read-oriented API extraction credentials exist outside GitHub | Keep read-oriented behavior and avoid committing credentials. |
| ERP/API behavior | GET/read-oriented extraction | Keep restricted to read behavior, with authentication/login as the limited exception. |
| PostgreSQL backup | Manual operator path using authorized admin access | Full backup should be handled privately by an authorized operator. |
| PostgreSQL restore test | Not always performed during handover | If deferred, document the risk privately and do not claim full restore has been proven. |

## Practical Rule

Do not break the working production access just to make the access model cleaner.

For handover, the safer position is:

```text
working but imperfect > theoretically cleaner but untested
```

## Power BI

Power BI should ideally use a read-only database role.

However, changing Power BI credentials can break scheduled refresh or local PBIX refresh if not tested carefully. Therefore:

- Keep the current working dashboard credential until a migration owner exists.
- Do not downgrade or revoke it during handover without a tested replacement.
- Create a cleaner read-only role only if someone will own the migration and test refresh afterward.

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

A full restore test is the ideal standard. If it is not performed, the documentation should clearly state that restore testing is deferred and should not claim full recovery has been proven.

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

But this should only be implemented after:

1. full backup is confirmed safe;
2. replacement admin access is tested;
3. Power BI refresh is tested after credential changes;
4. cron/ETL jobs are tested after credential changes.
