with source as (
    select * from {{ source('brightmart_raw', 'promotion_products') }}
),
renamed as (
    select
        try_to_number(nullif(trim(promotion_product_id), '')) as promotion_product_id,
        try_to_number(nullif(trim(promotion_id), '')) as promotion_id,
        try_to_number(nullif(trim(product_id), '')) as product_id
    from source
)
select * from renamed
