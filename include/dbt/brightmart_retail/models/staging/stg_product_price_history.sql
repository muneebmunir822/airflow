with source as (
    select * from {{ source('brightmart_raw', 'product_price_history') }}
),
renamed as (
    select
        try_to_number(nullif(trim(price_id), '')) as price_id,
        try_to_number(nullif(trim(product_id), '')) as product_id,
        {{ to_amount('list_price') }} as list_price,
        try_to_date(nullif(trim(effective_from), '')) as effective_from,
        try_to_date(nullif(trim(effective_to), '')) as effective_to
    from source
)
select * from renamed
