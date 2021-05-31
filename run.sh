curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json

docker cp pinot/debezium-def-table.json pinot:/opt/pinot
docker cp pinot/debezium-def-schema.json pinot:/opt/pinot

docker cp pinot/maxwell-def-table.json pinot:/opt/pinot
docker cp pinot/maxwell-def-schema.json pinot:/opt/pinot

docker exec pinot bash -c "/opt/pinot/bin/pinot-admin.sh AddTable -tableConfigFile /opt/pinot/debezium-def-table.json -schemaFile /opt/pinot/debezium-def-schema.json -exec"

docker exec pinot bash -c "/opt/pinot/bin/pinot-admin.sh AddTable -tableConfigFile /opt/pinot/maxwell-def-table.json -schemaFile /opt/pinot/maxwell-def-schema.json -exec"