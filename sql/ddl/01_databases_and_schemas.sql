create database if not exists RETAIL_DW;
create schema if not exists RETAIL_DW.raw_erp;
create schema if not exists RETAIL_DW.raw_crm;
create schema if not exists RETAIL_DW.raw_logistics;
create schema if not exists RETAIL_DW.staging;
create schema if not exists RETAIL_DW.intermediate;
create schema if not exists RETAIL_DW.marts;
create schema if not exists RETAIL_DW.seeds;

create warehouse if not exists INGEST_WH
  warehouse_size = 'xsmall'
  auto_suspend = 60
  auto_resume = true;

create warehouse if not exists TRANSFORMING_WH
  warehouse_size = 'medium'
  auto_suspend = 60
  auto_resume = true;
