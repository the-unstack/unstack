CREATE TABLE IF NOT EXISTS public.topic (
    id SERIAL PRIMARY KEY,
    topic TEXT NOT NULL,
    created_timestamp TIMESTAMPTZ NOT NULL,
    UNIQUE(topic)
);

-- Hypertable creation enables columnstore and creates its automatic policy.
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
