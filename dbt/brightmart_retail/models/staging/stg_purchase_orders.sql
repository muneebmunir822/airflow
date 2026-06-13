with source as (
    select * from {{ source('brightmart_raw', 'purchase_orders') }}
),
renamed as (
    select
        try_to_number(nullif(trim(purchase_order_id), '')) as purchase_order_id,
        {{ clean_text('po_number') }} as po_number,
        try_to_number(nullif(trim(supplier_id), '')) as supplier_id,
        try_to_number(nullif(trim(store_id), '')) as store_id,
        try_to_date(nullif(trim(order_date), '')) as order_date,
        try_to_date(nullif(trim(expected_date), '')) as expected_date,
        {{ clean_text('status') }} as status
    from source
)
select * from renamed
