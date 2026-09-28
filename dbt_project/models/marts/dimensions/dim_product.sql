{{ config(materialized='table', tags=['dimension', 'scd2']) }}

with products as (
    select * from {{ ref('stg_erp__products') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['product_id', 'source_updated_at']) }} as product_sk,
    product_id as product_nk,
    sku,
    product_name,
    category,
    subcategory,
    unit_cost,
    is_active,
    source_updated_at as valid_from,
    lead(source_updated_at) over (
        partition by product_id order by source_updated_at
    ) as valid_to,
    case
        when lead(source_updated_at) over (
            partition by product_id order by source_updated_at
        ) is null then true
        else false
    end as is_current
from products
