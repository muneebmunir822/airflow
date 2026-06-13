select
    st.store_name,
    p.department_name,
    p.category_name,
    p.product_name,
    f.quantity_on_hand,
    f.reorder_level
from {{ ref('fct_stock_snapshot') }} f
left join {{ ref('dim_stores') }} st on f.store_key = st.store_key
left join {{ ref('dim_products') }} p on f.product_key = p.product_key
where f.is_reorder_required
order by f.quantity_on_hand asc
