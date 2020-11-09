select
    ID as payment_id
    , ORDERID as order_id
    , PAYMENTMETHOD as payment_method
    , STATUS
    , cast(AMOUNT/100 as int) as amount_USD
    , CREATED
    , _BATCHED_AT

from {{ source('prod_stripe_db', 'payment') }}