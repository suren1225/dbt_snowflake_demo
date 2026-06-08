{{ config(
    materialized='table'
) }}

select

    product_id,

    product_name,

    category,

    sum(quantity) as units_sold,

    sum(sales_amount) as revenue,

    sum(total_cost) as total_cost,

    sum(profit) as margin,

    round(
        sum(profit) / nullif(sum(sales_amount),0) * 100,
        2
    ) as margin_pct

from {{ ref('int_order_details') }}

where status = 'COMPLETED'

group by
    product_id,
    product_name,
    category