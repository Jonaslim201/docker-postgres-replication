#!/bin/bash
set -e

# Wait until postgres is ready to accept connections
for i in {1..10}; do
	if pg_isready; then
		break
	fi
	sleep 1
done

echo "====== PostgreSQL Status Report ======"
echo "Container: $(hostname)"
pg_isready

echo "Recovery Mode Status:"
psql -U "$POSTGRES_USER" -d postgres -c "SELECT pg_is_in_recovery();"
echo "======================================"
