with returns as (select * from {{ ref('int_returns_validated') }}),
products as (select product_id, product_key from {{ ref('dim_products') }}),
dates as (select date_day, date_key from {{ ref('dim_date') }})
select
    {{ dbt_utils.generate_surrogate_key(['r.return_id']) }} as return_key,
    r.return_id,
    r.order_item_id,
    r.order_id,
    p.product_key,
    d.date_key as return_date_key,
    r.return_date,
    r.return_reason,
    r.quantity_returned,
    r.refund_amount,
    r.original_quantity_sold,
    r.is_return_quantity_excessive,
    r.created_at
from returns r
left join products p on r.product_id = p.product_id
left join dates d on r.return_date = d.date_day
