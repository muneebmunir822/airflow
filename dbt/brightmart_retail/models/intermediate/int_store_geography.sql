with stores as (select * from {{ ref('stg_stores') }}),
formats as (select * from {{ ref('stg_store_formats') }}),
addresses as (select * from {{ ref('stg_addresses') }}),
cities as (select * from {{ ref('stg_cities') }}),
regions as (select * from {{ ref('stg_regions') }}),
countries as (select * from {{ ref('stg_countries') }})
select
    s.store_id,
    s.store_code,
    s.store_name,
    s.opened_date,
    s.square_feet,
    s.manager_name,
    s.is_active,
    f.format_name,
    a.address_line1,
    a.address_line2,
    a.postal_code,
    c.city_name,
    r.region_name,
    co.country_code,
    co.country_name
from stores s
left join formats f on s.format_id = f.format_id
left join addresses a on s.address_id = a.address_id
left join cities c on a.city_id = c.city_id
left join regions r on c.region_id = r.region_id
left join countries co on r.country_id = co.country_id
