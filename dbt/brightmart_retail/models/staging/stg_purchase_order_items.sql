with source as (
    select * from {{ source('brightmart_raw', 'purchase_order_items') }}
),
renamed as (
    select
        try_to_number(nullif(trim(purchase_order_item_id), '')) as purchase_order_item_id,
        try_to_number(nullif(trim(purchase_order_id), '')) as purchase_order_id,
        try_to_number(nullif(trim(product_id), '')) as product_id,
        try_to_number(nullif(trim(quantity_ordered), '')) as quantity_ordered,
        {{ to_amount('unit_cost') }} as unit_cost,
        try_to_number(nullif(trim(quantity_received), '')) as quantity_received
    from source
)
select * from renamed
