CREATE TABLE testtable
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(50),
    value INTEGER
);

INSERT INTO testtable (name, value)
VALUES ('test', 1);
INSERT INTO testtable (name, value)
VALUES ('test', 2);
INSERT INTO testtable (name, value)
VALUES ('test', 3);
INSERT INTO testtable (name, value)
VALUES ('test', 4);
INSERT INTO testtable (name, value)
VALUES ('test', 5);
INSERT INTO testtable (name, value)
VALUES ('test', 6);

DELETE
FROM testtable
WHERE id = 3;
DELETE
FROM testtable
WHERE id = 4;

CREATE EXTENSION IF NOT EXISTS pglogical;
CREATE EXTENSION IF NOT EXISTS pgstattuple;

SELECT pglogical.create_node(
               node_name := 'source',
               dsn := 'host=pg-source port=5432 dbname=postgres user=postgres'
           );

SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']);