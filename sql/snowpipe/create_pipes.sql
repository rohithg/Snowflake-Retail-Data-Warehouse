-- Example Snowpipe setup for ERP order landings from S3
create or replace stage RETAIL_DW.raw_erp.ext_orders_stage
  url = 's3://your-bucket/retail/erp/orders/'
  storage_integration = S3_INT
  file_format = (type = parquet);

create or replace pipe RETAIL_DW.raw_erp.orders_pipe
  auto_ingest = true
as
copy into RETAIL_DW.raw_erp.orders
from @RETAIL_DW.raw_erp.ext_orders_stage
file_format = (type = parquet);
