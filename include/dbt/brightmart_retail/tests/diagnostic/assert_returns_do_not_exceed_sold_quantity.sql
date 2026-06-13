{{ config(severity='warn') }}
select return_id, order_item_id, quantity_returned, original_quantity_sold
from {{ ref('int_returns_validated') }}
where is_return_quantity_excessive
