with lines as (select * from {{ ref('int_sales_order_lines') }}),
customers as (select customer_id, customer_key from {{ ref('dim_customers') }}),
products as (select product_id, product_key from {{ ref('dim_products') }}),
stores as (select store_id, store_key from {{ ref('dim_stores') }}),
employees as (select employee_id, employee_key from {{ ref('dim_employees') }}),
promotions as (select promotion_id, promotion_key from {{ ref('dim_promotions') }}),
payments as (select payment_method_id, payment_method_key, method_name from {{ ref('dim_payment_methods') }}),
dates as (select date_day, date_key from {{ ref('dim_date') }})
select
    {{ dbt_utils.generate_surrogate_key(['l.order_item_id']) }} as sales_transaction_key,
    l.order_item_id,
    l.order_id,
    l.order_number,
    c.customer_key,
    p.product_key,
    s.store_key,
    e.employee_key,
    pr.promotion_key,
    d.date_key as order_date_key,
    l.order_date,
    l.order_time,
    l.channel,
    l.channel_group,
    l.order_status,
    l.payment_method,
    l.item_status,
    l.quantity,
    l.unit_price,
    l.item_discount_amount,
    l.calculated_gross_amount as gross_sales_amount,
    l.calculated_line_total as net_sales_amount,
    l.tax_amount,
    l.is_invalid_quantity,
    l.is_negative_discount,
    l.is_line_total_mismatch,
    l.is_order_total_mismatch,
    case
      when l.is_invalid_quantity or l.is_negative_discount or l.is_line_total_mismatch or l.is_order_total_mismatch then true
      else false
    end as has_quality_issue,
    l.updated_at
from lines l
left join customers c on l.customer_id = c.customer_id
left join products p on l.product_id = p.product_id
left join stores s on l.store_id = s.store_id
left join employees e on l.employee_id = e.employee_id
left join promotions pr on l.promotion_id = pr.promotion_id
left join dates d on l.order_date = d.date_day
