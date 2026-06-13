-- 01_create_raw_tables.sql
-- Creates RAW tables as loose VARCHAR landing tables for CSV ingestion.
create or replace database BRIGHTMART_DB;
create or replace warehouse BRIGHTMART_WH warehouse_size = 'XSMALL' auto_suspend = 60 auto_resume = true;
create or replace schema BRIGHTMART_DB.RAW;
use database BRIGHTMART_DB;
use schema RAW;

create or replace file format BRIGHTMART_DB.RAW.CSV_FF
  type = csv
  field_optionally_enclosed_by = '"'
  skip_header = 1
  null_if = ('', 'NULL', 'null')
  empty_field_as_null = true;

create or replace stage BRIGHTMART_DB.RAW.BRIGHTMART_STAGE file_format = BRIGHTMART_DB.RAW.CSV_FF;

create or replace table addresses (
    address_id varchar,
    city_id varchar,
    address_line1 varchar,
    address_line2 varchar,
    postal_code varchar
);

create or replace table brands (
    brand_id varchar,
    brand_name varchar
);

create or replace table categories (
    category_id varchar,
    department_id varchar,
    category_name varchar
);

create or replace table cities (
    city_id varchar,
    region_id varchar,
    city_name varchar
);

create or replace table countries (
    country_id varchar,
    country_code varchar,
    country_name varchar
);

create or replace table customer_addresses (
    customer_address_id varchar,
    customer_id varchar,
    address_id varchar,
    address_type varchar,
    is_default varchar
);

create or replace table customer_segments (
    segment_id varchar,
    segment_name varchar
);

create or replace table customers (
    customer_id varchar,
    customer_code varchar,
    first_name varchar,
    last_name varchar,
    gender varchar,
    birth_date varchar,
    email varchar,
    phone varchar,
    segment_id varchar,
    created_at varchar,
    updated_at varchar,
    is_active varchar,
    notes varchar
);

create or replace table departments (
    department_id varchar,
    department_name varchar
);

create or replace table employees (
    employee_id varchar,
    employee_code varchar,
    store_id varchar,
    first_name varchar,
    last_name varchar,
    job_title varchar,
    hire_date varchar,
    is_active varchar
);

create or replace table inventory_transactions (
    inventory_transaction_id varchar,
    store_id varchar,
    product_id varchar,
    transaction_date varchar,
    transaction_type varchar,
    quantity_change varchar,
    unit_cost varchar,
    reference_number varchar
);

create or replace table loyalty_accounts (
    loyalty_account_id varchar,
    customer_id varchar,
    loyalty_number varchar,
    enrollment_date varchar,
    tier varchar,
    points_balance varchar
);

create or replace table order_statuses (
    status_id varchar,
    status_name varchar
);

create or replace table payment_methods (
    payment_method_id varchar,
    method_name varchar
);

create or replace table product_cost_history (
    cost_id varchar,
    product_id varchar,
    cost_amount varchar,
    effective_from varchar,
    effective_to varchar
);

create or replace table product_price_history (
    price_id varchar,
    product_id varchar,
    list_price varchar,
    effective_from varchar,
    effective_to varchar
);

create or replace table products (
    product_id varchar,
    product_sku varchar,
    product_name varchar,
    subcategory_id varchar,
    brand_id varchar,
    supplier_id varchar,
    size varchar,
    color varchar,
    unit_of_measure varchar,
    standard_price varchar,
    status varchar,
    created_at varchar,
    updated_at varchar
);

create or replace table promotion_products (
    promotion_product_id varchar,
    promotion_id varchar,
    product_id varchar
);

create or replace table promotion_types (
    promotion_type_id varchar,
    promotion_type_name varchar
);

create or replace table promotions (
    promotion_id varchar,
    promotion_code varchar,
    promotion_name varchar,
    promotion_type_id varchar,
    start_date varchar,
    end_date varchar,
    discount_percent varchar,
    discount_amount varchar,
    is_active varchar
);

create or replace table purchase_order_items (
    purchase_order_item_id varchar,
    purchase_order_id varchar,
    product_id varchar,
    quantity_ordered varchar,
    unit_cost varchar,
    quantity_received varchar
);

create or replace table purchase_orders (
    purchase_order_id varchar,
    po_number varchar,
    supplier_id varchar,
    store_id varchar,
    order_date varchar,
    expected_date varchar,
    status varchar
);

create or replace table regions (
    region_id varchar,
    country_id varchar,
    region_name varchar
);

create or replace table returns (
    return_id varchar,
    order_item_id varchar,
    return_date varchar,
    return_reason varchar,
    quantity_returned varchar,
    refund_amount varchar,
    created_at varchar
);

create or replace table sales_order_items (
    order_item_id varchar,
    order_id varchar,
    product_id varchar,
    promotion_id varchar,
    quantity varchar,
    unit_price varchar,
    discount_amount varchar,
    line_total varchar,
    item_status varchar,
    updated_at varchar
);

create or replace table sales_orders (
    order_id varchar,
    order_number varchar,
    customer_id varchar,
    store_id varchar,
    employee_id varchar,
    order_date varchar,
    order_time varchar,
    status_id varchar,
    payment_method_id varchar,
    channel varchar,
    subtotal_amount varchar,
    tax_amount varchar,
    discount_amount varchar,
    total_amount varchar,
    created_at varchar,
    updated_at varchar
);

create or replace table stock_levels (
    stock_level_id varchar,
    store_id varchar,
    product_id varchar,
    quantity_on_hand varchar,
    reorder_level varchar,
    last_stocktake_date varchar
);

create or replace table store_formats (
    format_id varchar,
    format_name varchar
);

create or replace table stores (
    store_id varchar,
    store_code varchar,
    store_name varchar,
    address_id varchar,
    format_id varchar,
    opened_date varchar,
    square_feet varchar,
    manager_name varchar,
    is_active varchar
);

create or replace table subcategories (
    subcategory_id varchar,
    category_id varchar,
    subcategory_name varchar
);

create or replace table suppliers (
    supplier_id varchar,
    supplier_name varchar,
    contact_email varchar,
    phone varchar,
    country_id varchar
);
