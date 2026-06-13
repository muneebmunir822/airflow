{{ config(severity='warn') }}
select order_item_id, order_id, quantity
from {{ ref('stg_sales_order_items') }}
where is_invalid_quantity
