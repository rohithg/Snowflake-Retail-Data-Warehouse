{{
  config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge',
    tags=['fact']
  )
}}

with orders as (
    select * from {{ ref('stg_erp__orders') }}
    {% if is_incremental() %}
      where order_date >= dateadd(day, -3, current_date)
    {% endif %}
),

customers as (
    select * from {{ ref('dim_customer') }} where is_current
)

select
    o.order_id,
    c.customer_sk,
    cast(to_char(o.order_date, 'YYYYMMDD') as int) as order_date_sk,
    o.order_ts,
    o.order_date,
    o.order_status,
    o.currency_code,
    o.total_amount
from orders o
left join customers c on o.customer_id = c.customer_nk
