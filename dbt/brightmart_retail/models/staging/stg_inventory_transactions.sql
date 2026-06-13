with source as (
    select * from {{ source('brightmart_raw', 'inventory_transactions') }}
),
renamed as (
    select
        try_to_number(nullif(trim(inventory_transaction_id), '')) as inventory_transaction_id,
        try_to_number(nullif(trim(store_id), '')) as store_id,
        try_to_number(nullif(trim(product_id), '')) as product_id,
        try_to_date(nullif(trim(transaction_date), '')) as transaction_date,
        {{ clean_text('transaction_type') }} as transaction_type,
        try_to_number(nullif(trim(quantity_change), '')) as quantity_change,
        {{ to_amount('unit_cost') }} as unit_cost,
        {{ clean_text('reference_number') }} as reference_number
    from source
)
select * from renamed
