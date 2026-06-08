select

    customer_id,
    customer_name,
    city,
    country,
    segment,

    dbt_valid_from,
    dbt_valid_to

from {{ ref('customer_snapshot') }}