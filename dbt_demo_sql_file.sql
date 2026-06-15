SELECT CURRENT_ACCOUNT(),CURRENT_REGION(),CURRENT_ROLE(),CURRENT_WAREHOUSE(),CURRENT_DATABASE();

CREATE WAREHOUSE IF NOT EXISTS DEMO_WH
WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

DROP DATABASE ANALYTICS_DB;

CREATE DATABASE IF NOT EXISTS ANALYTICS_DB;
USE DATABASE ANALYTICS_DB;

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CUSTOM_LOG_METADATA;
-- CREATE SCHEMA IF NOT EXISTS STAGING;
-- CREATE SCHEMA IF NOT EXISTS INTERMEDIATE;
-- CREATE SCHEMA IF NOT EXISTS MARTS;

SELECT CURRENT_SCHEMA();

SHOW WAREHOUSES;
SHOW DATABASES;
SHOW SCHEMAS;

USE WAREHOUSE DEMO_WH;
USE DATABASE ANALYTICS_DB;
USE SCHEMA RAW;

SELECT CURRENT_USER();
SELECT CURRENT_SCHEMA();
CREATE OR REPLACE STAGE RAW_STAGE;

SHOW STAGES;

--upload files to stage

list @raw_stage;
 
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

SHOW FILE FORMATS;

CREATE OR REPLACE TABLE RAW.CUSTOMERS (
    customer_id NUMBER,
    name STRING,
    city STRING,
    country STRING,
    signup_date DATE,
    segment STRING
);

CREATE OR REPLACE TABLE RAW.PRODUCTS (
    product_id STRING,
    name STRING,
    category STRING,
    cost_price NUMBER(10,2),
    supplier_id NUMBER
);

CREATE OR REPLACE TABLE RAW.ORDERS (
    order_id STRING,
    customer_id NUMBER,
    product_id STRING,
    order_date DATE,
    quantity NUMBER,
    unit_price NUMBER(10,2),
    status STRING
);

SHOW tables;

use schema CUSTOM_LOG_METADATA;

 CREATE TABLE IF NOT EXISTS AUDIT_LOG (
    audit_id NUMBER AUTOINCREMENT,
    model_name STRING,
    audit_type STRING,
    row_count NUMBER,
    audit_timestamp TIMESTAMP
);


USE SCHEMA RAW;

COPY INTO RAW.CUSTOMERS
FROM @RAW_STAGE/customer.csv
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT');

COPY INTO RAW.ORDERS
FROM @RAW_STAGE/orders.csv
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT');

COPY INTO RAW.PRODUCTS
FROM @RAW_STAGE/product.csv
FILE_FORMAT=(FORMAT_NAME='CSV_FORMAT');


select * from RAW.CUSTOMERS;
select * from RAW.ORDERS;
select * from RAW.PRODUCTS;

--dbt debug
--dbt clean
--dbt deps
--dbt compile

--dbt run --select staging

select * from staging.stg_CUSTOMERS;
select * from staging.stg_products;
select * from staging.stg_orders;

---dbt test --select staging

select * from staging.stg_orders
where order_id='O99999';

INSERT INTO RAW.ORDERS
VALUES
(
'O99999',
1001,
'P001',
CURRENT_DATE(),
1,
900,
'Completed'
);

select * from RAW.ORDERS
where order_id='O99999';
 
--dbt run --select stg_orders
--dbt test --select stg_orders

select * from staging.stg_orders 
where order_id='O99999';


--upload seed file to folder
--dbt seed

--dbt run --select intermediate
--dbt test --select intermediate

select * from intermediate.int_order_details;

select
order_id,
count(*)
from RAW.ORDERS
group by 1
having count(*) > 1;

select *
from RAW.CUSTOMERS
where customer_id is null;

select distinct status
from RAW.ORDERS;

select *
from ANALYTICS_DB.INTERMEDIATE.INT_ORDER_DETAILS
limit 10;

select *
from ANALYTICS_DB.INTERMEDIATE.INT_ORDER_DETAILS
limit 10;

--dbt snapshot

select * from snapshots.customer_snapshot;
SHOW SCHEMAS;


--dbt run --select marts

select * from ANALYTICS_DB.marts.mart_customer_summary;

select * from ANALYTICS_DB.marts.mart_daily_sales;

select * from ANALYTICS_DB.marts.mart_product_performance;

select * from ANALYTICS_DB.marts.mart_customer_history;


select * from CUSTOM_LOG_METADATA.AUDIT_LOG;