with po as (select * from {{ ref('stg_purchase_orders') }}),
poi as (select * from {{ ref('stg_purchase_order_items') }}),
products as (select product_id, product_key from {{ ref('dim_products') }}),
stores as (select store_id, store_key from {{ ref('dim_stores') }}),
suppliers as (select supplier_id, supplier_key from {{ ref('dim_suppliers') }}),
dates as (select date_day, date_key from {{ ref('dim_date') }})
select
    {{ dbt_utils.generate_surrogate_key(['poi.purchase_order_item_id']) }} as purchase_order_line_key,
    po.purchase_order_id,
    poi.purchase_order_item_id,
    po.po_number,
    sup.supplier_key,
    st.store_key,
    product_key,
    d.date_key as order_date_key,
    po.order_date,
    po.expected_date,
    po.status,
    poi.quantity_ordered,
    poi.quantity_received,
    poi.unit_cost,
    poi.quantity_ordered * poi.unit_cost as ordered_cost_amount,
    poi.quantity_received * poi.unit_cost as received_cost_amount
from poi
inner join po on poi.purchase_order_id = po.purchase_order_id
left join products p on poi.product_id = p.product_id
left join stores st on po.store_id = st.store_id
left join suppliers sup on po.supplier_id = sup.supplier_id
left join dates d on po.order_date = d.date_day
