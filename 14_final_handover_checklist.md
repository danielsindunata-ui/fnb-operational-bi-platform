# Final Handover Checklist

## Purpose

This checklist tracks the remaining handover state for the BI platform in a sanitized, public-safe format.

Production backup paths, checksums, credential names, account names, hostnames, server paths, and internal command outputs should be stored privately outside GitHub.

## Checklist

| Item | Status | Evidence / Next Action |
|---|---|---|
| Live database inventory generated | Done | Summary retained in `docs/13_live_database_inventory.md`; full output stored privately outside GitHub. |
| Schema-only backup exists | Done | Backup artifact stored privately outside GitHub. |
| Full PostgreSQL data-bearing backup created | Done | Completed by authorized operator; artifact stored privately outside GitHub. |
| Full backup verified with `pg_restore --list` | Done | Restore-list verification confirms the archive can be read/listed, not that a full restore has been tested. |
| Backup copied outside production server | Done | Off-server copy completed by operator. |
| Restore test completed | Deferred | A full restore test into a separate database is ideal. If not performed, do not claim full restore has been proven. |
| Power BI credential documented privately | Done | Current production access should be stored in a private credential inventory, not GitHub. |
| ETL database credential documented privately | Done | Current ETL access path should be stored in a private credential inventory, not GitHub. |
| ERP/API extraction credential documented privately | Done | API account/token details should remain outside GitHub. |
| Google Sheets inputs documented | Partial | Confirm company ownership/permissions outside GitHub. |
| Access cleanup plan reviewed | Done | No revokes/downgrades should happen without tested replacement access. |
| Database dumps excluded from GitHub | Done | No dump, `.env`, credential, checksum file, restore-list file, or raw data file should be committed. |

## Immediate Follow-Up Order

1. Keep the full backup and off-server copy safe.
2. Keep working Power BI access stable unless someone is ready to test a credential migration.
3. Keep ERP/API ETL read-oriented and preserve guardrails.
4. Confirm Google Sheets ownership and latest PBIX storage.
5. Create/test a new break-glass admin path if someone will own it properly.
6. Do not downgrade current working credentials unless the replacement path has been tested.

## Safety Rules Still In Force

- Do not run destructive SQL during handover.
- Do not revoke, downgrade, or rotate credentials unless replacement access is tested.
- Do not commit `.env` files, dumps, checksum files, restore-list files, tokens, service account files, raw exports, or credentials.
- Do not expose internal hostnames, paths, backup filenames, API account names, or database account names in public documentation.
- Do not change mart logic without confirming Power BI consumers and validating before/after outputs.
