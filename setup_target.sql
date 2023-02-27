CREATE
EXTENSION IF NOT EXISTS pglogical;
CREATE EXTENSION IF NOT EXISTS pgstattuple;

SELECT pglogical.create_node(
node_name := 'subscriber',
dsn := 'host=pg-target port=5432 dbname=postgres user=postgres'
);

SELECT pglogical.create_subscription(
subscription_name := 'subscription1',
provider_dsn := 'host=pg-source port=5432 dbname=postgres user=postgres',
synchronize_structure := true,
synchronize_data := true
);

select pglogical.wait_for_subscription_sync_complete('subscription1');

