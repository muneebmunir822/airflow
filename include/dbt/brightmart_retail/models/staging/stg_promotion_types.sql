with source as (
    select * from {{ source('brightmart_raw', 'promotion_types') }}
),
renamed as (
    select
        try_to_number(nullif(trim(promotion_type_id), '')) as promotion_type_id,
        {{ clean_text('promotion_type_name') }} as promotion_type_name
    from source
)
select * from renamed
