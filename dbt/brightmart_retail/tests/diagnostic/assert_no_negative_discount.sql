{{ config(severity='warn') }}
select order_item_id, order_id, discount_amount
from {{ ref('stg_sales_order_items') }}
where is_negative_discount
