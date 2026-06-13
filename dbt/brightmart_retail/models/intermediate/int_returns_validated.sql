with returns as (select * from {{ ref('stg_returns') }}),
items as (select * from {{ ref('stg_sales_order_items') }})
select
    r.return_id,
    r.order_item_id,
    i.order_id,
    i.product_id,
    r.return_date,
    r.return_reason,
    r.quantity_returned,
    r.refund_amount,
    r.created_at,
    i.quantity as original_quantity_sold,
    case when r.quantity_returned > i.quantity then true else false end as is_return_quantity_excessive
from returns r
left join items i on r.order_item_id = i.order_item_id
