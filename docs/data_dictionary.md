# Data dictionary

## Facts

| Model | Grain | Description |
|-------|-------|-------------|
| `fct_orders` | one row per order | Header-level order metrics |
| `fct_order_items` | one row per order line | Line revenue and margin |
| `fct_shipments` | one row per shipment | Freight cost and delivery SLA |

## Dimensions

| Model | SCD | Natural key |
|-------|-----|-------------|
| `dim_customer` | Type 2 | `customer_id` |
| `dim_product` | Type 2 | `product_id` |
| `dim_date` | Type 1 | calendar day |
| `dim_carrier` | Type 1 | `carrier_id` |
