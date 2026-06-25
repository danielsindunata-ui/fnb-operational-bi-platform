# Access and Credential Safety Notes

## Purpose

This document describes the access model and handover principles for the BI platform in a sanitized, public-safe way.

It intentionally avoids exposing live usernames, account names, passwords, tokens, hostnames, server paths, database names, backup paths, or credential file names.

## Public-Safe Principle

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

## Important Order of Operations

Do **not** downgrade or rotate working credentials before replacement access is tested.

Correct order:

```text
create replacement admin path
        ↓
test replacement access
        ↓
create and verify backup
        ↓
store credentials safely
        ↓
identify where existing credentials are used
        ↓
create/test scoped roles
        ↓
migrate Power BI / ETL access carefully
        ↓
test refresh, ETL jobs, backup, and restore process
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
