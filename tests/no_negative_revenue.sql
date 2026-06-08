select *
from {{ ref('int_order_details') }}
where sales_amount < 0