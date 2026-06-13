{% snapshot snap_products_check %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['product_name', 'subcategory_id', 'brand_id', 'supplier_id', 'standard_price', 'status']
    )
}}

select
    try_to_number(product_id) as product_id,
    product_sku,
    product_name,
    try_to_number(subcategory_id) as subcategory_id,
    try_to_number(brand_id) as brand_id,
    try_to_number(supplier_id) as supplier_id,
    try_to_decimal(standard_price, 18, 2) as standard_price,
    status,
    try_to_timestamp_ntz(updated_at) as updated_at
from {{ source('brightmart_raw', 'products') }}

{% endsnapshot %}
