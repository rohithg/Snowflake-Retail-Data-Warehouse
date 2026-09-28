{{
  config(
    materialized='incremental',
    unique_key='shipment_id',
    incremental_strategy='merge',
    tags=['fact']
  )
}}

with shipments as (
    select * from {{ ref('stg_logistics__shipments') }}
    {% if is_incremental() %}
      where shipment_date >= dateadd(day, -3, current_date)
    {% endif %}
),

carriers as (
    select * from {{ ref('dim_carrier') }}
)

select
    s.shipment_id,
    s.order_id,
    c.carrier_sk,
    cast(to_char(s.shipment_date, 'YYYYMMDD') as int) as shipment_date_sk,
    s.shipped_at,
    s.delivered_at,
    s.shipment_status,
    s.freight_cost,
    timediff(hour, s.shipped_at, s.delivered_at) as delivery_hours
from shipments s
left join carriers c on s.carrier_id = c.carrier_nk
