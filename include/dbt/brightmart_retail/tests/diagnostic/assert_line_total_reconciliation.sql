{{ config(severity='warn') }}
select order_item_id, order_id, line_total, calculated_line_total
from {{ ref('stg_sales_order_items') }}
where is_line_total_mismatch
