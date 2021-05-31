# MySQL Debezium vs. Maxwell Kafka Pinot CDC Flow

This is another tryout I prepared to demonstrate CDC (change data capture).

[Here](https://mert.codes/hello-hello-i-detected-a-change-on-this-database-1bdadea6b4c6) is my post about this tryout.

### The Ingredients

- Source database
- Change observers (producers)
- Message broker
- Destination (consumer)

### Technologies Used

- MySQL
- Debezium
- Maxwell
- Kafka
- Apache Pinot

### To Run

_**Note:** If you get `Docker Container exited with code 137` errors during running and experimenting, chances are that your Docker Desktop -> Resources -> Memory amount is not enough. I have set my resource settings as follows: CPUs 6, Memory 8 GB, Swap 1 GB._

Open up a terminal and browse to the cloned folder and execute the following command to see the magic happen:

`docker-compose up`

Or to have everything run at the background silently, add -d

`docker-compose up -d`

Open another terminal and execute a script to start Debezium MySQL connector and create table in Apache Pinot::

`./run.sh`

Browse Apache Pinot UI to query some data

http://localhost:9000/#/query

Open an SQL client and use the following information to connect:
> Host: 127.0.0.1  
Port:13306  
User: root  
Password: debezium

_**Note:** Some SQL clients (like Sequel Pro) are incompatible with the Docker image._

Insert new records to / update existing records in / delete records from `customers` table of the inventory database.

Execute the following SQL to see the captured changes:

> SELECT
JSONEXTRACTSCALAR(full_payload, '$.source.db', 'STRING') AS source_db,
JSONEXTRACTSCALAR(full_payload, '$.source.table', 'STRING') AS source_table,
JSONEXTRACTSCALAR(full_payload, '$.ts_ms', 'STRING') AS time_stamp,
JSONEXTRACTSCALAR(full_payload, '$.op', 'STRING') AS operation,
JSONEXTRACTSCALAR(full_payload, '$.after', 'STRING') AS after
FROM poc_debezium

> SELECT * FROM poc_maxwell