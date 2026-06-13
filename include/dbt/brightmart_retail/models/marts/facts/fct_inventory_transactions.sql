with inv as (select * from {{ ref('stg_inventory_transactions') }}),
products as (select product_id, product_key from {{ ref('dim_products') }}),
stores as (select store_id, store_key from {{ ref('dim_stores') }}),
dates as (select date_day, date_key from {{ ref('dim_date') }})
select
    {{ dbt_utils.generate_surrogate_key(['inv.inventory_transaction_id']) }} as inventory_transaction_key,
    inv.inventory_transaction_id,
    s.store_key,
    p.product_key,
    d.date_key as transaction_date_key,
    inv.transaction_date,
    inv.transaction_type,
    inv.quantity_change,
    inv.unit_cost,
    inv.reference_number
from inv
left join products p on inv.product_id = p.product_id
left join stores s on inv.store_id = s.store_id
left join dates d on inv.transaction_date = d.date_day
