select orders.order_id, orders.customer_id, orders.order_date, sum(amount_USD) as amount_USD
from {{ ref('stg_orders') }} as orders
inner join {{ ref('stg_payment') }} as payment
on orders.ORDER_ID = payment.ORDER_ID
where payment.status = 'success'
group by 1,2,3
order by 1