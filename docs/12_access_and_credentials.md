# Access and Credential Safety Notes

## Purpose

This document describes the access model and handover principles for the BI platform in a sanitized, public-safe way.

It intentionally avoids exposing live usernames, account names, passwords, tokens, hostnames, server paths, database names, backup paths, or credential file names.

## Public-Safe Principle

This repository may describe **types of access** and **security responsibilities**, but it must not document production secrets or live operational identifiers.

Allowed in this repository:

- Role categories
- Access-design principles
- Handover risks
- Recommended credential separation
- What should be stored outside GitHub

Not allowed in this repository:

- Passwords
- API tokens
- JWT tokens
- Service account keys
- Live database usernames
- Live API account usernames
- Live server usernames or paths
- Production hostnames or internal IP addresses
- Connection strings
- Raw `.env` files
- Production backup filenames, checksums, or dump paths

## Recommended Access Groups

| Credential / Role Type | Purpose | Access Level | Priority |
|---|---|---|---|
| Database superadmin / break-glass role | Emergency administration | Full admin | Must be stored securely outside GitHub |
| Backup operator | Database backup and restore | Enough to dump/restore required schemas/data | High |
| Power BI reader | Dashboard refresh | Read-only on dashboard-facing marts | High |
| ETL service role | Scheduled extraction and transformation | Limited read/write needed by ETL jobs | High |
| Audit reader | Manual SQL checks | Read-only | Useful |
| API reader | ERP/API extraction | Read-oriented API access | Required for extraction |
| Google Sheets service account | Planning input sync | Sheet/API access only | Useful |

## Power BI Access Rule

Power BI should ideally connect using a read-only or near-read-only database role.

Power BI should not use:

```text
superadmin credentials
personal database admin credentials
write-capable ETL credentials
```

## ETL Access Rule

ETL jobs may need write access because extraction and transformation jobs load data into the database.

The ETL credential should have enough access to load raw, clean, planning, and mart objects as required, but it should not be reused for Power BI refresh or casual dashboard checks.

## API Access Rule

ERP/API extraction should remain read-oriented.

Expected pattern:

```text
GET/read extraction
+ authentication/login exception only
```

Extraction code should not be loosened to perform write/update/delete behavior unless there is an explicit business requirement, owner approval, and safe testing process.

## Backup Access Rule

Backups must be possible without depending on one person's personal superuser session.

A backup-capable role should be able to create a full database backup and should be tested with restore-list verification and, ideally, a restore into a separate test database.

## Minimum Practical Handover Target

```text
1. One known working admin path exists.
2. A backup-capable role can create a full dump with data.
3. Current credential usage is documented privately.
4. Power BI does not use a superadmin credential.
5. ETL credential usage is documented privately.
6. Backup location exists outside the production server.
7. Secrets are not stored in GitHub.
```

## What Should Not Be Committed to GitHub

Never commit:

```text
.env files
passwords
API tokens
JWT tokens
service account JSON keys
PostgreSQL dumps
Power BI files containing credentials
raw sales exports
supplier price exports
customer or employee data
production backup paths or checksums
internal hostnames or IP addresses
```

GitHub should contain documentation and sanitized code/examples, not secrets or production data.
