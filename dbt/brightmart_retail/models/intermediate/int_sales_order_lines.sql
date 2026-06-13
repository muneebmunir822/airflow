with orders as (select * from {{ ref('stg_sales_orders') }}),
items as (select * from {{ ref('stg_sales_order_items') }}),
statuses as (select * from {{ ref('stg_order_statuses') }}),
payments as (select * from {{ ref('stg_payment_methods') }})
select
    i.order_item_id,
    o.order_id,
    o.order_number,
    o.customer_id,
    o.store_id,
    o.employee_id,
    i.product_id,
    i.promotion_id,
    o.order_date,
    o.order_time,
    o.channel,
    o.channel_group,
    s.status_name as order_status,
    p.method_name as payment_method,
    i.item_status,
    i.is_sales_eligible,
    i.quantity,
    i.unit_price,
    i.discount_amount as item_discount_amount,
    i.line_total,
    i.calculated_gross_amount,
    i.calculated_line_total,
    o.tax_amount,
    o.total_amount as order_total_amount,
    i.is_invalid_quantity,
    i.is_negative_discount,
    i.is_line_total_mismatch,
    o.is_order_total_mismatch,
    greatest(i.updated_at, o.updated_at) as updated_at
from items i
inner join orders o on i.order_id = o.order_id
left join statuses s on o.status_id = s.status_id
left join payments p on o.payment_method_id = p.payment_method_id
