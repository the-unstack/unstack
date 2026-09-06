DELETE FROM "process_value_numeric";
DELETE FROM "process_value_text";
DELETE FROM "topic";
-- Cached topic ids (Redis) expire after 24h and are evicted on FK error.
-- To flush now: docker exec connect-global-to-postgres-redis redis-cli FLUSHALL
