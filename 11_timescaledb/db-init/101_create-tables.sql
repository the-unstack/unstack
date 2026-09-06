CREATE TABLE IF NOT EXISTS public.topic (
    id SERIAL PRIMARY KEY,
    topic TEXT NOT NULL,
    created_timestamp TIMESTAMPTZ NOT NULL,
    UNIQUE(topic)
);

-- Hypertable creation enables columnstore and creates an implicit policy (after = chunk_interval), replaced below.
-- FK on topic_id is intentional: 10_ relies on the FK error to evict stale cached topic ids.
CREATE TABLE IF NOT EXISTS public.process_value_numeric (
    timestamp TIMESTAMPTZ NOT NULL,
    topic_id INTEGER NOT NULL REFERENCES topic(id),
    value DOUBLE PRECISION NULL,
    UNIQUE(timestamp, topic_id)
) WITH (
   tsdb.hypertable,
   tsdb.partition_column='timestamp',
   tsdb.chunk_interval='1 day',
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
   tsdb.chunk_interval='1 day',
   tsdb.segmentby = 'topic_id',
   tsdb.orderby = 'timestamp DESC'
);

-- explicit columnstore policies (replace the implicit after=chunk_interval ones); no retention: lab keeps everything
CALL remove_columnstore_policy('public.process_value_numeric', if_exists => true);
CALL add_columnstore_policy('public.process_value_numeric', after => INTERVAL '7 days');
CALL remove_columnstore_policy('public.process_value_text', if_exists => true);
CALL add_columnstore_policy('public.process_value_text', after => INTERVAL '7 days');
