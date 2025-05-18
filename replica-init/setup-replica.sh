set -e

if [ ! -s /var/lib/postgresql/data/PG_VERSION ]; then
	echo "Waiting 3 seconds for master to be ready..."
	sleep 3
	echo "pg-master:5432:replication:replica:replicapass" >/var/lib/postgresql/.pgpass
	chmod 600 /var/lib/postgresql/.pgpass
	chown postgres:postgres /var/lib/postgresql/.pgpass

	echo "Cloning data from master..."
	PGPASSFILE=/var/lib/postgresql/.pgpass pg_basebackup -h pg-master -p 5432 -D /var/lib/postgresql/data -U replica -Fp -Xs -P -R
	chown -R postgres:postgres /var/lib/postgresql/data
fi

echo "Starting postgres..."
exec docker-entrypoint.sh postgres
