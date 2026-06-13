with source as (
    select * from {{ source('brightmart_raw', 'returns') }}
),
renamed as (
    select
        try_to_number(nullif(trim(return_id), '')) as return_id,
        try_to_number(nullif(trim(order_item_id), '')) as order_item_id,
        try_to_date(nullif(trim(return_date), '')) as return_date,
        {{ clean_text('return_reason') }} as return_reason,
        try_to_number(nullif(trim(quantity_returned), '')) as quantity_returned,
        {{ to_amount('refund_amount') }} as refund_amount,
        try_to_timestamp_ntz(nullif(trim(created_at), '')) as created_at
    from source
)
select * from renamed
