{{
  config(
    materialized='table',
    tags=['dimension', 'scd2']
  )
}}

with customers as (
    select * from {{ ref('stg_crm__customers') }}
),

staged as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'source_updated_at']) }} as customer_sk,
        customer_id as customer_nk,
        account_id,
        email,
        first_name,
        last_name,
        country_code,
        region,
        customer_segment,
        customer_created_at,
        source_updated_at as valid_from,
        lead(source_updated_at) over (
            partition by customer_id order by source_updated_at
        ) as valid_to,
        case
            when lead(source_updated_at) over (
                partition by customer_id order by source_updated_at
            ) is null then true
            else false
        end as is_current
    from customers
)

select * from staged
