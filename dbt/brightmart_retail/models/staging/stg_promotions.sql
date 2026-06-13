with source as (
    select * from {{ source('brightmart_raw', 'promotions') }}
),
renamed as (
    select
        try_to_number(nullif(trim(promotion_id), '')) as promotion_id,
        {{ clean_text('promotion_code') }} as promotion_code,
        {{ clean_text('promotion_name') }} as promotion_name,
        try_to_number(nullif(trim(promotion_type_id), '')) as promotion_type_id,
        try_to_date(nullif(trim(start_date), '')) as start_date,
        try_to_date(nullif(trim(end_date), '')) as end_date,
        {{ to_amount('discount_percent') }} as discount_percent,
        {{ to_amount('discount_amount') }} as discount_amount,
        {{ to_boolean('is_active') }} as is_active
    from source
)
select * from renamed
