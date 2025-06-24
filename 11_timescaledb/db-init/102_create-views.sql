CREATE VIEW process_value_numeric_with_topic AS
SELECT pv.timestamp, t.topic, pv.value
FROM "process_value_numeric" pv
INNER JOIN topic t ON pv.topic_id = t.id
ORDER BY pv."timestamp" DESC;

CREATE VIEW process_value_text_with_topic AS
SELECT pv.timestamp, t.topic, pv.value
FROM "process_value_text" pv
INNER JOIN topic t ON pv.topic_id = t.id
ORDER BY pv."timestamp" DESC;