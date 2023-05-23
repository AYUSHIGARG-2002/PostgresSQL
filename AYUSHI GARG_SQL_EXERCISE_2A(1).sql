 --1. Get list of tables 
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'; 

--2. Get list of columns and data types
SELECT column_name, data_type FROM information_schema.columns; 

 --3. Get list of Schema, tables, columns. 
SELECT table_schema, table_name, column_name, data_type FROM information_schema.columns; 

--4. Get list of constraints (Primary Key, Foreign Key, Check Constraints).
SELECT 
  tc.constraint_name, 
  tc.constraint_type, 
  tc.table_name, 
  kcu.column_name, 
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name LEFT JOIN information_schema.constraint_column_usage AS ccu  ON ccu.constraint_name = tc.constraint_name;  

--6. Get list of indexes for each tables.
SELECT tablename, indexname, indexdef FROM pg_indexes WHERE schemaname = 'public';

--9. Calculate size of each table and total database size.
SELECT
    table_name,
    pg_size_pretty(total_bytes) AS total_size,
    pg_size_pretty(index_bytes) AS index_size,
    pg_size_pretty(toast_bytes) AS toast_size,
    pg_size_pretty(table_bytes) AS table_size
FROM (
    SELECT
        c.oid,
        nspname AS table_schema,
        relname AS table_name,
        SUM(pg_total_relation_size(c.oid)) AS total_bytes,
        SUM(pg_indexes_size(c.oid)) AS index_bytes,
        SUM(pg_total_relation_size(reltoastrelid)) AS toast_bytes,
        SUM(pg_total_relation_size(c.oid) - pg_total_relation_size(reltoastrelid) - pg_indexes_size(c.oid)) AS table_bytes
    FROM pg_class c
    LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE relkind = 'r'
    GROUP BY c.oid, nspname, relname
) AS table_sizes;

--10. Get list of users and related permissions.
SELECT 
    pg_user.usename AS username,
    pg_authid.rolsuper AS is_superuser,
    pg_authid.rolcreaterole AS can_create_role,
    pg_authid.rolcreatedb AS can_create_db,
    pg_authid.rolinherit AS can_inherit_role,
    pg_authid.rolreplication AS is_replication_role,
    pg_authid.rolbypassrls AS can_bypass_rls,
    array_agg(DISTINCT pg_authid.rolname) AS member_of,
    array_agg(DISTINCT pg_database.datname) AS can_access_databases,
    array_agg(DISTINCT pg_namespace.nspname) AS can_access_schemas,
    array_agg(DISTINCT pg_class.relname) AS can_access_tables
FROM pg_user
LEFT JOIN pg_auth_members ON pg_user.usesysid = pg_auth_members.member
LEFT JOIN pg_authid ON pg_auth_members.roleid = pg_authid.oid
LEFT JOIN pg_database ON pg_authid.oid = pg_database.datdba
LEFT JOIN pg_namespace ON pg_authid.oid = pg_namespace.nspowner
LEFT JOIN pg_class ON pg_authid.oid = pg_class.relowner
GROUP BY pg_user.usename, pg_authid.rolsuper, pg_authid.rolcreaterole, pg_authid.rolcreatedb, pg_authid.rolinherit, pg_authid.rolreplication, pg_authid.rolbypassrls;







