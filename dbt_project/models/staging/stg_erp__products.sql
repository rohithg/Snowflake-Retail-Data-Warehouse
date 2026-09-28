with source as (
    select * from {{ source('erp', 'products') }}
),

renamed as (
    select
        product_id::varchar as product_id,
        sku::varchar as sku,
        product_name::varchar as product_name,
        category::varchar as category,
        subcategory::varchar as subcategory,
        unit_cost::number(18, 4) as unit_cost,
        is_active::boolean as is_active,
        updated_at::timestamp_ntz as source_updated_at,
        _loaded_at::timestamp_ntz as _loaded_at
    from source
)

select * from renamed
