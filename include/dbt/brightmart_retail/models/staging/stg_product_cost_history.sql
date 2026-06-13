with source as (
    select * from {{ source('brightmart_raw', 'product_cost_history') }}
),
renamed as (
    select
        try_to_number(nullif(trim(cost_id), '')) as cost_id,
        try_to_number(nullif(trim(product_id), '')) as product_id,
        {{ to_amount('cost_amount') }} as cost_amount,
        try_to_date(nullif(trim(effective_from), '')) as effective_from,
        try_to_date(nullif(trim(effective_to), '')) as effective_to
    from source
)
select * from renamed
