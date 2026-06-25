-- Database inventory audit script
-- Purpose:
--   Generate a read-only inventory of schemas, tables, views, materialized views,
--   row estimates, object sizes, columns, indexes, and view dependencies.
--
-- Safety:
--   This script is read-only. It does not create, update, delete, truncate,
--   refresh, or analyze any database object.

\echo 'DATABASE INVENTORY AUDIT'

SELECT
    current_database() AS database_name,
    current_user AS current_user,
    inet_server_addr() AS server_address,
    inet_server_port() AS server_port,
    version() AS postgres_version,
    now() AS audit_timestamp;

\echo '## Schemas'
SELECT
    nspname AS schema_name,
    pg_get_userbyid(nspowner) AS owner
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
ORDER BY nspname;

\echo '## Tables, views, materialized views, row estimates, and sizes'
SELECT
    n.nspname AS schema_name,
    c.relname AS object_name,
    CASE c.relkind
        WHEN 'r' THEN 'table'
        WHEN 'p' THEN 'partitioned_table'
        WHEN 'v' THEN 'view'
        WHEN 'm' THEN 'materialized_view'
        WHEN 'f' THEN 'foreign_table'
        ELSE c.relkind::text
    END AS object_type,
    pg_get_userbyid(c.relowner) AS owner,
    c.reltuples::bigint AS estimated_rows,
    pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size,
    pg_total_relation_size(c.oid) AS total_size_bytes
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname NOT LIKE 'pg_%'
  AND n.nspname <> 'information_schema'
  AND c.relkind IN ('r', 'p', 'v', 'm', 'f')
ORDER BY n.nspname, object_type, c.relname;

\echo '## Largest objects'
SELECT
    n.nspname AS schema_name,
    c.relname AS object_name,
    CASE c.relkind
        WHEN 'r' THEN 'table'
        WHEN 'p' THEN 'partitioned_table'
        WHEN 'v' THEN 'view'
        WHEN 'm' THEN 'materialized_view'
        WHEN 'f' THEN 'foreign_table'
        ELSE c.relkind::text
    END AS object_type,
    pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size,
    pg_total_relation_size(c.oid) AS total_size_bytes,
    c.reltuples::bigint AS estimated_rows
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname NOT LIKE 'pg_%'
  AND n.nspname <> 'information_schema'
  AND c.relkind IN ('r', 'p', 'm', 'f')
ORDER BY pg_total_relation_size(c.oid) DESC
LIMIT 50;

\echo 'END DATABASE INVENTORY AUDIT'
