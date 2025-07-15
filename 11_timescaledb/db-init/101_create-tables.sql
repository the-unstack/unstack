CREATE TABLE IF NOT EXISTS public.topic (
    id SERIAL PRIMARY KEY,
    topic TEXT NOT NULL,
    created_timestamp TIMESTAMPTZ NOT NULL,
    UNIQUE(topic)
);

CREATE TABLE IF NOT EXISTS public.process_value_numeric (
    timestamp TIMESTAMPTZ NOT NULL,
    topic_id INTEGER NOT NULL REFERENCES topic(id),
    value DOUBLE PRECISION NULL,
    UNIQUE(timestamp, topic_id)
) WITH (
   tsdb.hypertable,
   tsdb.partition_column='timestamp',
   tsdb.segmentby = 'topic_id',
   tsdb.orderby = 'timestamp DESC'
);

CREATE TABLE IF NOT EXISTS public.process_value_text (
    timestamp TIMESTAMPTZ NOT NULL,
    topic_id INTEGER NOT NULL REFERENCES topic(id),
    value TEXT NULL,
    UNIQUE(timestamp, topic_id)
) WITH (
   tsdb.hypertable,
   tsdb.partition_column='timestamp',
   tsdb.segmentby = 'topic_id',
   tsdb.orderby = 'timestamp DESC'
);

ALTER TABLE "process_value_numeric" SET(
   timescaledb.enable_columnstore,
   timescaledb.orderby = 'timestamp DESC',
   timescaledb.segmentby = 'topic_id');

ALTER TABLE "process_value_text" SET(
   timescaledb.enable_columnstore,
   timescaledb.orderby = 'timestamp DESC',
   timescaledb.segmentby = 'topic_id');

CALL add_columnstore_policy('process_value_numeric', INTERVAL '4 weeks');
CALL add_columnstore_policy('process_value_text', INTERVAL '4 weeks');
