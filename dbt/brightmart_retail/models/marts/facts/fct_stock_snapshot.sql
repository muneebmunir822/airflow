with stock as (select * from {{ ref('stg_stock_levels') }}),
products as (select product_id, product_key from {{ ref('dim_products') }}),
stores as (select store_id, store_key from {{ ref('dim_stores') }}),
dates as (select date_day, date_key from {{ ref('dim_date') }})
select
    {{ dbt_utils.generate_surrogate_key(['stock.stock_level_id']) }} as stock_snapshot_key,
    s.store_key,
    p.product_key,
    d.date_key as stocktake_date_key,
    stock.last_stocktake_date,
    stock.quantity_on_hand,
    stock.reorder_level,
    case when stock.quantity_on_hand <= stock.reorder_level then true else false end as is_reorder_required
from stock
left join products p on stock.product_id = p.product_id
left join stores s on stock.store_id = s.store_id
left join dates d on stock.last_stocktake_date = d.date_day
