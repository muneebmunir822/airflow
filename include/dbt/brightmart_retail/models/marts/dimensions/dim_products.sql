select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_sku,
    product_name,
    brand_name,
    supplier_id,
    supplier_name,
    department_name,
    category_name,
    subcategory_name,
    size,
    color,
    unit_of_measure,
    standard_price,
    status,
    created_at,
    updated_at
from {{ ref('int_product_hierarchy') }}
