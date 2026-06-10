{{
    config(
        materialized='view',

        pre_hook=[
            "{{ audit_row_count(ref('stg_orders'), 'BEFORE') }}"
        ],

        post_hook=[
            "{{ audit_row_count(this, 'AFTER') }}"
        ]
    )
}}

select

    o.order_id,
    o.order_date,

    o.customer_id,
    c.customer_name,
    c.city,
    c.country,
    c.segment,

    o.product_id,
    p.product_name,

    coalesce(pc.category, p.category) as category,          -- from seed (override/enrichment)
    p.supplier_id,

    o.quantity,
    o.unit_price,
    o.sales_amount,

    p.cost_price,
    (o.quantity * p.cost_price) as total_cost,
    (o.sales_amount - (o.quantity * p.cost_price)) as profit,
    o.status

from {{ ref('stg_orders') }} o
left join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id
left join {{ ref('stg_products') }} p
    on o.product_id = p.product_id
left join {{ ref('product_category') }} pc
    on p.product_id = pc.product_id