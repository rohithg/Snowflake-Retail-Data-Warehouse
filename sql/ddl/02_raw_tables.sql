create or replace table RETAIL_DW.raw_erp.orders (
  order_id varchar,
  customer_id varchar,
  order_ts timestamp_ntz,
  status varchar,
  currency_code varchar,
  total_amount number(18,2),
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_erp.order_lines (
  order_line_id varchar,
  order_id varchar,
  product_id varchar,
  quantity number(18,4),
  unit_price number(18,4),
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_erp.products (
  product_id varchar,
  sku varchar,
  product_name varchar,
  category varchar,
  subcategory varchar,
  unit_cost number(18,4),
  is_active boolean,
  updated_at timestamp_ntz,
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_erp.inventory (
  snapshot_date date,
  product_id varchar,
  location_id varchar,
  on_hand_qty number(18,4),
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_crm.customers (
  customer_id varchar,
  account_id varchar,
  email varchar,
  first_name varchar,
  last_name varchar,
  country_code varchar,
  region varchar,
  customer_segment varchar,
  created_at timestamp_ntz,
  updated_at timestamp_ntz,
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_crm.accounts (
  account_id varchar,
  account_name varchar,
  industry varchar,
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_logistics.shipments (
  shipment_id varchar,
  order_id varchar,
  carrier_id varchar,
  origin_location_id varchar,
  dest_location_id varchar,
  shipped_at timestamp_ntz,
  delivered_at timestamp_ntz,
  status varchar,
  freight_cost number(18,2),
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_logistics.carriers (
  carrier_id varchar,
  carrier_name varchar,
  service_level varchar,
  _loaded_at timestamp_ntz default current_timestamp()
);

create or replace table RETAIL_DW.raw_logistics.delivery_events (
  event_id varchar,
  shipment_id varchar,
  event_type varchar,
  event_ts timestamp_ntz,
  _loaded_at timestamp_ntz default current_timestamp()
);
