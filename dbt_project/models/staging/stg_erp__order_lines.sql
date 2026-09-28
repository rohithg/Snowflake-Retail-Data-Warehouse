with source as (
    select * from {{ source('erp', 'order_lines') }}
),

renamed as (
    select
        order_line_id::varchar as order_line_id,
        order_id::varchar as order_id,
        product_id::varchar as product_id,
        quantity::number(18, 4) as quantity,
        unit_price::number(18, 4) as unit_price,
        (quantity * unit_price)::number(18, 2) as extended_amount,
        _loaded_at::timestamp_ntz as _loaded_at
    from source
)

select * from renamed
