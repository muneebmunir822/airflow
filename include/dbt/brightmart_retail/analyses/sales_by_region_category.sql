-- This analysis compiles but does not run automatically. Use dbt compile and copy the compiled SQL to Snowflake.
select
    st.region_name,
    p.category_name,
    sum(f.quantity) as total_quantity,
    sum(f.net_sales_amount) as net_sales_amount
from {{ ref('fct_sales') }} f
left join {{ ref('dim_stores') }} st on f.store_key = st.store_key
left join {{ ref('dim_products') }} p on f.product_key = p.product_key
group by 1, 2
order by 4 desc
