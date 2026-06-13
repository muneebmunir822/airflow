with source as (
    select * from {{ source('brightmart_raw', 'payment_methods') }}
),
renamed as (
    select
        try_to_number(nullif(trim(payment_method_id), '')) as payment_method_id,
        {{ clean_text('method_name') }} as method_name
    from source
)
select * from renamed
