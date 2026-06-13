with source as (
    select * from {{ source('brightmart_raw', 'stock_levels') }}
),
renamed as (
    select
        try_to_number(nullif(trim(stock_level_id), '')) as stock_level_id,
        try_to_number(nullif(trim(store_id), '')) as store_id,
        try_to_number(nullif(trim(product_id), '')) as product_id,
        try_to_number(nullif(trim(quantity_on_hand), '')) as quantity_on_hand,
        try_to_number(nullif(trim(reorder_level), '')) as reorder_level,
        try_to_date(nullif(trim(last_stocktake_date), '')) as last_stocktake_date
    from source
)
select * from renamed
