{% snapshot customer_snapshot %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='customer_id',
        strategy='check',
        check_cols=['segment', 'city', 'country'],
        invalidate_hard_deletes=True
    )
}}

select
    customer_id,
    customer_name,
    city,
    country,
    segment
from {{ ref('stg_customers') }}

{% endsnapshot %}