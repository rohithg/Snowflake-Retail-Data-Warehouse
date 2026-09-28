select
    ol.order_line_id,
    ol.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    ol.product_id,
    ol.quantity,
    ol.unit_price,
    ol.extended_amount,
    p.category as product_category,
    p.unit_cost,
    (ol.extended_amount - (ol.quantity * p.unit_cost))::number(18, 2) as gross_margin
from {{ ref('stg_erp__order_lines') }} ol
inner join {{ ref('stg_erp__orders') }} o using (order_id)
left join {{ ref('stg_erp__products') }} p using (product_id)
