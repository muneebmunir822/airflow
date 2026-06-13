with source as (
    select * from {{ source('brightmart_raw', 'subcategories') }}
),
renamed as (
    select
        try_to_number(nullif(trim(subcategory_id), '')) as subcategory_id,
        try_to_number(nullif(trim(category_id), '')) as category_id,
        {{ clean_text('subcategory_name') }} as subcategory_name
    from source
)
select * from renamed
