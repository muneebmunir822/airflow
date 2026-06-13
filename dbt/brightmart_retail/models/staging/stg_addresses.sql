with source as (
    select * from {{ source('brightmart_raw', 'addresses') }}
),
renamed as (
    select
        try_to_number(nullif(trim(address_id), '')) as address_id,
        try_to_number(nullif(trim(city_id), '')) as city_id,
        {{ clean_text('address_line1') }} as address_line1,
        {{ clean_text('address_line2') }} as address_line2,
        {{ clean_text('postal_code') }} as postal_code
    from source
)
select * from renamed
