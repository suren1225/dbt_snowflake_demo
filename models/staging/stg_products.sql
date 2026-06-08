select
    cast(product_id as varchar) as product_id,
    trim(name) as product_name,
    trim(category) as category,
    cast(cost_price as decimal(10,2)) as cost_price,
    cast(supplier_id as number) as supplier_id
from {{ source('raw','products') }}