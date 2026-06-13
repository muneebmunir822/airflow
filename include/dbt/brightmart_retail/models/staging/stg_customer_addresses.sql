with source as (
    select * from {{ source('brightmart_raw', 'customer_addresses') }}
),
renamed as (
    select
        try_to_number(nullif(trim(customer_address_id), '')) as customer_address_id,
        try_to_number(nullif(trim(customer_id), '')) as customer_id,
        try_to_number(nullif(trim(address_id), '')) as address_id,
        {{ clean_text('address_type') }} as address_type,
        {{ to_boolean('is_default') }} as is_default
    from source
)
select * from renamed
