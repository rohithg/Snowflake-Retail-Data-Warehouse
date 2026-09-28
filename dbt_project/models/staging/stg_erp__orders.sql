with source as (
    select * from {{ source('erp', 'orders') }}
),

renamed as (
    select
        order_id::varchar as order_id,
        customer_id::varchar as customer_id,
        order_ts::timestamp_ntz as order_ts,
        cast(order_ts as date) as order_date,
        status::varchar as order_status,
        currency_code::varchar as currency_code,
        total_amount::number(18, 2) as total_amount,
        _loaded_at::timestamp_ntz as _loaded_at
    from source
)

select * from renamed
