#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	  CREATE ROLE replica WITH REPLICATION LOGIN PASSWORD 'replicapass';
	  GRANT CONNECT ON DATABASE postgres TO replica;
	  GRANT USAGE ON SCHEMA public TO replica;
	  GRANT SELECT ON ALL TABLES IN SCHEMA public TO replica;
	  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO replica;
EOSQL

echo "host replication replica 0.0.0.0/0 md5" >>"$PGDATA/pg_hba.conf"
echo "wal_level = replica" >>"$PGDATA/postgresql.conf"
echo "max_wal_senders = 10" >>"$PGDATA/postgresql.conf"
echo "wal_keep_size = 64" >>"$PGDATA/postgresql.conf"
echo "listen_addresses = '*'" >>"$PGDATA/postgresql.conf"
