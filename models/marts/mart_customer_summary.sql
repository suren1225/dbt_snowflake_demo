{{ config(
    materialized='table'
) }}

select

    customer_id,

    customer_name,

    city,

    country,

    segment,

    count(distinct order_id) as total_orders,

    sum(sales_amount) as lifetime_value,

    avg(sales_amount) as avg_order_value,

    min(order_date) as first_order_date,

    max(order_date) as last_order_date

from {{ ref('int_order_details') }}

where status = 'COMPLETED'

group by
    customer_id,
    customer_name,
    city,
    country,
    segment