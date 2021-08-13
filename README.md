# entity_dump
arangodump --server.endpoint tcp://localhost:8529 --server.username root --server.database entity3 --include-system-collections true -output-directory entity_dump3

arangorestore -c none --server.endpoint "tcp://127.0.0.1:8529"  --server.username "root" --server.database entity3 --create-database true --force-same-database --include-system-collections  --input-directory "./entity_dump3/
