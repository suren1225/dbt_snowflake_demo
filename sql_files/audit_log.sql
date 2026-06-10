CREATE TABLE IF NOT EXISTS AUDIT_LOG (
    audit_id NUMBER AUTOINCREMENT,
    model_name STRING,
    audit_type STRING,
    row_count NUMBER,
    audit_timestamp TIMESTAMP
);