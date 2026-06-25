# Final Handover Checklist

## Purpose

This checklist tracks the remaining handover state for the BI platform in a sanitized, public-safe format.

Production backup paths, checksums, credential names, account names, hostnames, server paths, and internal command outputs should be stored privately outside GitHub.

## Status Legend

| Status | Meaning |
|---|---|
| Done | Verified in the handover pass |
| Partial | Some work completed, but follow-up remains |
| Pending | Not completed yet |
| Blocked | Cannot be completed until a specific access/owner action happens |
| External | Must be done outside this repository/session |
| Deferred | Intentionally not being completed now; risk is accepted/documented |

## Checklist

| Item | Status | Evidence / Next Action |
|---|---|---|
| Live database inventory generated | Done | Summary retained in sanitized documentation; full output stored privately outside GitHub. |
| Schema-only backup exists | Done | Backup artifact stored privately outside GitHub. |
| Full PostgreSQL data-bearing backup created | Done | Completed by authorized operator; artifact stored privately outside GitHub. |
| Full backup checksum generated | Done | Checksum stored privately outside GitHub. |
| Full backup verified with `pg_restore --list` | Done | Restore-list verification confirms the archive can be read/listed, not that a full restore has been tested. |
| Backup copied outside production server | Done | Off-server copy completed by operator. |
| Restore test completed | Deferred | A full restore test into a separate database is ideal. If not performed, do not claim full restore has been proven. |
| Power BI credential documented privately | Done | Current production access should be stored in a private credential inventory, not GitHub. |
| ETL database credential documented privately | Done | Current ETL access path should be stored in a private credential inventory, not GitHub. |
| ERP/API extraction credential documented privately | Done | API account/token details should remain outside GitHub. |
| ERP/API guardrail documented | Done | Extraction behavior should remain read-oriented, with auth/login as the limited exception. |
| Google Sheets inputs documented | Partial | Confirm company ownership/permissions outside GitHub. |
| Cron jobs documented | Done | Public docs should describe cadence only; exact server paths should remain private. |
| Known data quality issues documented | Partial | See `docs/08_data_quality.md`. |
| Dashboard troubleshooting guide reviewed | Done | `docs/11_troubleshooting_wrong_numbers.md` exists and should remain the first guide for wrong/stale numbers. |
| Access cleanup plan reviewed | Done | See `docs/12_access_and_credentials.md`; no revokes/downgrades should happen without tested replacement access. |
| New break-glass superadmin created and tested | Pending | Recommended if the system will continue long-term. Test login before changing existing shared credentials. |
| Current shared credential downgraded | Deferred | Do not force this during handover. Downgrade only after replacement admin and tested read-only/service roles exist. |
| Power BI switched to read-only user | Deferred | Cleaner long-term target, but only safe if someone owns and tests the migration. |
| Database dumps excluded from GitHub | Done | No dump, `.env`, credential, checksum file, restore-list file, or raw data file should be committed. |

## Immediate Follow-Up Order

1. Keep the full backup and off-server copy safe.
2. Keep working Power BI access stable unless someone is ready to test a credential migration.
3. Keep ERP/API ETL read-oriented and preserve guardrails.
4. Confirm Google Sheets ownership and latest PBIX storage.
5. Create/test a new break-glass admin path if someone will own it properly.
6. Do not downgrade current working credentials unless the replacement path has been tested.

## Accepted Handover Risk

A full restore test may be deferred.

The accepted practical evidence is:

- full custom-format PostgreSQL dump exists;
- SHA256 checksum exists;
- `pg_restore --list` completed;
- off-server copy was completed by operator.

This is not as strong as a full restore test, but it is materially better than having no data-bearing backup.

## Safety Rules Still In Force

- Do not run destructive SQL during handover.
- Do not revoke, downgrade, or rotate credentials unless replacement access is tested and dashboard/ETL refresh are confirmed afterward.
- Do not commit `.env` files, dumps, checksum files, restore-list files, tokens, service account files, raw exports, or credentials.
- Do not expose internal hostnames, paths, backup filenames, API account names, or database account names in public documentation.
- Do not change mart logic without confirming Power BI consumers and validating before/after outputs.
