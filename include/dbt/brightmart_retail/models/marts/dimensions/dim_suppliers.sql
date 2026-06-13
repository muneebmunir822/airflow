with suppliers as (select * from {{ ref('stg_suppliers') }}),
countries as (select * from {{ ref('stg_countries') }})
select
    {{ dbt_utils.generate_surrogate_key(['s.supplier_id']) }} as supplier_key,
    s.supplier_id,
    s.supplier_name,
    s.contact_email,
    s.phone,
    c.country_code,
    c.country_name
from suppliers s
left join countries c on s.country_id = c.country_id
