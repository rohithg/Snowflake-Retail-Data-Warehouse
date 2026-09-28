{{ config(materialized='table', tags=['dimension']) }}

select
    {{ dbt_utils.generate_surrogate_key(['carrier_id']) }} as carrier_sk,
    carrier_id as carrier_nk,
    carrier_name,
    service_level
from {{ ref('stg_logistics__carriers') }}
