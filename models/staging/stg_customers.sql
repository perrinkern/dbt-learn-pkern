select
    id as customer_id,
    first_name,
    last_name

from {{ source('prod_jaffle_shop_db', 'customers') }}