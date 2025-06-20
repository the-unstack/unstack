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
);

CREATE TABLE IF NOT EXISTS public.process_value_text (
    timestamp TIMESTAMPTZ NOT NULL,
    topic_id INTEGER NOT NULL REFERENCES topic(id),
    value TEXT NULL,
    UNIQUE(timestamp, topic_id)
);

SELECT create_hypertable('process_value_numeric', 'timestamp');
SELECT create_hypertable('process_value_text', 'timestamp');

