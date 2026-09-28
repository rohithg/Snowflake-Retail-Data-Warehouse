with source as (
    select * from {{ source('logistics', 'shipments') }}
),

renamed as (
    select
        shipment_id::varchar as shipment_id,
        order_id::varchar as order_id,
        carrier_id::varchar as carrier_id,
        origin_location_id::varchar as origin_location_id,
        dest_location_id::varchar as dest_location_id,
        shipped_at::timestamp_ntz as shipped_at,
        cast(shipped_at as date) as shipment_date,
        delivered_at::timestamp_ntz as delivered_at,
        status::varchar as shipment_status,
        freight_cost::number(18, 2) as freight_cost,
        _loaded_at::timestamp_ntz as _loaded_at
    from source
)

select * from renamed
