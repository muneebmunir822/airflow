select
    {{ dbt_utils.generate_surrogate_key(['store_id']) }} as store_key,
    store_id,
    store_code,
    store_name,
    format_name,
    opened_date,
    square_feet,
    manager_name,
    is_active,
    address_line1,
    address_line2,
    postal_code,
    city_name,
    region_name,
    country_code,
    country_name
from {{ ref('int_store_geography') }}
