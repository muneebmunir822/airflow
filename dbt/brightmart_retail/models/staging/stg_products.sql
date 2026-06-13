with source as (
    select * from {{ source('brightmart_raw', 'products') }}
),
renamed as (
    select
        try_to_number(nullif(trim(product_id), '')) as product_id,
        {{ clean_text('product_sku') }} as product_sku,
        {{ clean_text('product_name') }} as product_name,
        try_to_number(nullif(trim(subcategory_id), '')) as subcategory_id,
        try_to_number(nullif(trim(brand_id), '')) as brand_id,
        try_to_number(nullif(trim(supplier_id), '')) as supplier_id,
        {{ clean_text('size') }} as size,
        {{ clean_text('color') }} as color,
        {{ clean_text('unit_of_measure') }} as unit_of_measure,
        {{ to_amount('standard_price') }} as standard_price,
        {{ clean_text('status') }} as status,
        try_to_timestamp_ntz(nullif(trim(created_at), '')) as created_at,
        try_to_timestamp_ntz(nullif(trim(updated_at), '')) as updated_at
    from source
)
select * from renamed
