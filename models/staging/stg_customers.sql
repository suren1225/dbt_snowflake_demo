select
    cast(customer_id as number) as customer_id,
    trim(name) as customer_name,
    trim(city) as city,
    trim(country) as country,
    cast(signup_date as date) as signup_date,
    coalesce(segment,'UNKNOWN') as segment
from {{ source('raw','customers') }}