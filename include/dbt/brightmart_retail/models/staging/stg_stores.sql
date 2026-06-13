with source as (
    select * from {{ source('brightmart_raw', 'stores') }}
),
renamed as (
    select
        try_to_number(nullif(trim(store_id), '')) as store_id,
        {{ clean_text('store_code') }} as store_code,
        {{ clean_text('store_name') }} as store_name,
        try_to_number(nullif(trim(address_id), '')) as address_id,
        try_to_number(nullif(trim(format_id), '')) as format_id,
        try_to_date(nullif(trim(opened_date), '')) as opened_date,
        try_to_number(nullif(trim(square_feet), '')) as square_feet,
        {{ clean_text('manager_name') }} as manager_name,
        {{ to_boolean('is_active') }} as is_active
    from source
)
select * from renamed
