with source as (
    select * from {{ source('brightmart_raw', 'suppliers') }}
),
renamed as (
    select
        try_to_number(nullif(trim(supplier_id), '')) as supplier_id,
        {{ clean_text('supplier_name') }} as supplier_name,
        {{ clean_email('contact_email') }} as contact_email,
        {{ clean_text('phone') }} as phone,
        try_to_number(nullif(trim(country_id), '')) as country_id
    from source
)
select * from renamed
