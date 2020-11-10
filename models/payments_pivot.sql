-- 1. Can you dynamically populate the loop list with some sql query?
-- 2. How do we stop m a k i n g a l l t h i s happen?
-- 3. Can we avoid leading commas as the solution? (should we?)
-- 4. If we have a new payment method, how do we handle this?
    --can do a test to check for "extra" values, or keep static to avoid breaking downstream reports
-- Bonus: Is there a better way?

--{% set methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] %}
{%- set payment_methods_query %}
select distinct payment_method from {{ ref('stg_payment') }}
order by 1
{% endset -%}

{%- set results = run_query(payment_methods_query) %}

{%- if execute %}
--{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif -%}


with

payments as (

    select * from {{ ref('stg_payment') }}

),

final as (

    select
        order_id,

        {% for payment_method in results_list -%}
        sum(case when payment_method = '{{payment_method}}' then amount_usd else 0 end) as {{payment_method}}_amount
        {%- if not loop.last -%}
        ,
        {% endif -%}
        {% endfor %}

    from payments
    group by 1

)

select * from final