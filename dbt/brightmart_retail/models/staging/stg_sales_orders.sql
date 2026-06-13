with source as (
    select * from {{ source('brightmart_raw', 'sales_orders') }}
),
channel_map as (
    select * from {{ ref('channel_normalization') }}
),
cleaned as (
    select
        try_to_number(order_id) as order_id,
        {{ clean_text('order_number') }} as order_number,
        try_to_number(customer_id) as customer_id,
        try_to_number(store_id) as store_id,
        try_to_number(employee_id) as employee_id,
        try_to_date(order_date) as order_date,
        try_to_time(order_time) as order_time,
        try_to_number(status_id) as status_id,
        try_to_number(payment_method_id) as payment_method_id,
        coalesce(cm.channel_standard, initcap(trim(source.channel))) as channel,
        coalesce(cm.channel_group, 'Other') as channel_group,
        {{ to_amount('subtotal_amount') }} as subtotal_amount,
        {{ to_amount('tax_amount') }} as tax_amount,
        {{ to_amount('discount_amount') }} as discount_amount,
        {{ to_amount('total_amount') }} as total_amount,
        try_to_timestamp_ntz(created_at) as created_at,
        try_to_timestamp_ntz(updated_at) as updated_at,
        case
          when abs({{ to_amount('total_amount') }} - ({{ to_amount('subtotal_amount') }} + {{ to_amount('tax_amount') }} - {{ to_amount('discount_amount') }})) > 0.01 then true
          else false
        end as is_order_total_mismatch
    from source
    left join channel_map cm
      on upper(trim(source.channel)) = upper(trim(cm.raw_channel))
)
select * from cleaned
