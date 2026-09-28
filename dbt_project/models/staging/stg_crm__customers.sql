with source as (
    select * from {{ source('crm', 'customers') }}
),

renamed as (
    select
        customer_id::varchar as customer_id,
        account_id::varchar as account_id,
        trim(lower(email)) as email,
        initcap(trim(first_name)) as first_name,
        initcap(trim(last_name)) as last_name,
        country_code::varchar as country_code,
        region::varchar as region,
        customer_segment::varchar as customer_segment,
        created_at::timestamp_ntz as customer_created_at,
        updated_at::timestamp_ntz as source_updated_at,
        _loaded_at::timestamp_ntz as _loaded_at
    from source
)

select * from renamed
