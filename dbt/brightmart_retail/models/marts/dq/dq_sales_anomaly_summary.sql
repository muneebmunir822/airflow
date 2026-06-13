select 'invalid_quantity' as anomaly_type, count(*) as anomaly_count from {{ ref('fct_sales') }} where is_invalid_quantity
union all
select 'negative_discount', count(*) from {{ ref('fct_sales') }} where is_negative_discount
union all
select 'line_total_mismatch', count(*) from {{ ref('fct_sales') }} where is_line_total_mismatch
union all
select 'order_total_mismatch', count(*) from {{ ref('fct_sales') }} where is_order_total_mismatch
union all
select 'any_quality_issue', count(*) from {{ ref('fct_sales') }} where has_quality_issue
