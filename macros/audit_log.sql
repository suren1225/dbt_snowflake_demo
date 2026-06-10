{% macro audit_row_count(table_name, audit_type) %}

insert into CUSTOM_LOG_METADATA.AUDIT_LOG
(
    model_name,
    audit_type,
    row_count,
    audit_timestamp
)
select
    '{{ table_name }}',
    '{{ audit_type }}',
    count(*),
    current_timestamp()
from {{ table_name }}

{% endmacro %}