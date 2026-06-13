with source as (
    select * from {{ source('brightmart_raw', 'brands') }}
),
renamed as (
    select
        try_to_number(nullif(trim(brand_id), '')) as brand_id,
        {{ clean_text('brand_name') }} as brand_name
    from source
)
select * from renamed
