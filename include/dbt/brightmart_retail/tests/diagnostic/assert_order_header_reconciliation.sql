{{ config(severity='warn') }}
select order_id, order_number, subtotal_amount, tax_amount, discount_amount, total_amount
from {{ ref('stg_sales_orders') }}
where is_order_total_mismatch
