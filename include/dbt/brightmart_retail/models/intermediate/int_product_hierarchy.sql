with products as (select * from {{ ref('stg_products') }}),
subcategories as (select * from {{ ref('stg_subcategories') }}),
categories as (select * from {{ ref('stg_categories') }}),
departments as (select * from {{ ref('stg_departments') }}),
brands as (select * from {{ ref('stg_brands') }}),
suppliers as (select * from {{ ref('stg_suppliers') }})
select
    p.product_id,
    p.product_sku,
    p.product_name,
    p.size,
    p.color,
    p.unit_of_measure,
    p.standard_price,
    p.status,
    p.created_at,
    p.updated_at,
    b.brand_id,
    b.brand_name,
    s.supplier_id,
    s.supplier_name,
    sc.subcategory_id,
    sc.subcategory_name,
    c.category_id,
    c.category_name,
    d.department_id,
    d.department_name
from products p
left join subcategories sc on p.subcategory_id = sc.subcategory_id
left join categories c on sc.category_id = c.category_id
left join departments d on c.department_id = d.department_id
left join brands b on p.brand_id = b.brand_id
left join suppliers s on p.supplier_id = s.supplier_id
