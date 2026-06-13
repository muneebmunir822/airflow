select
    {{ dbt_utils.generate_surrogate_key(['status_id']) }} as order_status_key,
    status_id,
    status_name
from {{ ref('stg_order_statuses') }}
