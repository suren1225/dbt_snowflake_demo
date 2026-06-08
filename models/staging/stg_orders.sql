{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    unit_price,
    quantity * unit_price as sales_amount,
    upper(trim(status)) as status

from {{ source('raw','orders') }}

{% if is_incremental() %}

where order_date >
(
    select max(order_date)
    from {{ this }}
)

{% endif %}