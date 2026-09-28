{{ config(materialized='table', tags=['dimension']) }}

with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ var('start_date') ~ "' as date)",
        end_date="dateadd(year, 2, current_date)"
    ) }}
)

select
    cast(to_char(date_day, 'YYYYMMDD') as int) as date_sk,
    date_day as date_day,
    date_part('year', date_day) as year,
    date_part('quarter', date_day) as quarter,
    date_part('month', date_day) as month,
    to_char(date_day, 'MMMM') as month_name,
    date_part('week', date_day) as week_of_year,
    date_part('dayofweekiso', date_day) as day_of_week,
    to_char(date_day, 'DY') as day_name,
    case when date_part('dayofweekiso', date_day) in (6, 7) then true else false end as is_weekend
from spine
