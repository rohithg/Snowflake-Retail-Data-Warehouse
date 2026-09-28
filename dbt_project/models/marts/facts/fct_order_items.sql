{{
  config(
    materialized='incremental',
    unique_key='order_line_id',
    incremental_strategy='merge',
    tags=['fact']
  )
}}

with items as (
    select * from {{ ref('int_order_items_enriched') }}
    {% if is_incremental() %}
      where order_date >= dateadd(day, -3, current_date)
    {% endif %}
),

products as (
    select * from {{ ref('dim_product') }} where is_current
),

customers as (
    select * from {{ ref('dim_customer') }} where is_current
)

select
    i.order_line_id,
    i.order_id,
    c.customer_sk,
    p.product_sk,
    cast(to_char(i.order_date, 'YYYYMMDD') as int) as order_date_sk,
    i.quantity,
    i.unit_price,
    i.extended_amount,
    i.gross_margin,
    i.order_status,
    i.product_category
from items i
left join products p on i.product_id = p.product_nk
left join customers c on i.customer_id = c.customer_nk
