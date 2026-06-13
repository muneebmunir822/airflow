with source as (
    select * from {{ source('brightmart_raw', 'sales_order_items') }}
),
status_map as (
    select * from {{ ref('item_status_normalization') }}
),
cleaned as (
    select
        try_to_number(order_item_id) as order_item_id,
        try_to_number(order_id) as order_id,
        try_to_number(product_id) as product_id,
        try_to_number(promotion_id) as promotion_id,
        try_to_number(quantity) as quantity,
        {{ to_amount('unit_price') }} as unit_price,
        {{ to_amount('discount_amount') }} as discount_amount,
        {{ to_amount('line_total') }} as line_total,
        coalesce(sm.item_status_standard, initcap(trim(source.item_status))) as item_status,
        try_to_boolean(sm.is_sales_eligible) as is_sales_eligible,
        try_to_timestamp_ntz(updated_at) as updated_at,
        try_to_number(quantity) * {{ to_amount('unit_price') }} as calculated_gross_amount,
        (try_to_number(quantity) * {{ to_amount('unit_price') }}) - {{ to_amount('discount_amount') }} as calculated_line_total,
        case when try_to_number(quantity) <= 0 then true else false end as is_invalid_quantity,
        case when {{ to_amount('discount_amount') }} < 0 then true else false end as is_negative_discount,
        case
          when abs({{ to_amount('line_total') }} - ((try_to_number(quantity) * {{ to_amount('unit_price') }}) - {{ to_amount('discount_amount') }})) > 0.01 then true
          else false
        end as is_line_total_mismatch
    from source
    left join status_map sm
      on upper(trim(source.item_status)) = upper(trim(sm.raw_item_status))
)
select * from cleaned
