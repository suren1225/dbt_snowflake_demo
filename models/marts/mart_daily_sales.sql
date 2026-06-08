{{ config(
    materialized='table'
) }}

select

    order_date,

    count(distinct order_id) as order_count,

    sum(sales_amount) as total_revenue,

    avg(sales_amount) as avg_order_value,

    sum(quantity) as total_units_sold

from {{ ref('int_order_details') }}

where status = 'COMPLETED'

group by order_date