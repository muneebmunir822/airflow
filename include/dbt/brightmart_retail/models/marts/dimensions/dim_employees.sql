select
    {{ dbt_utils.generate_surrogate_key(['employee_id']) }} as employee_key,
    employee_id,
    employee_code,
    store_id,
    concat(first_name, ' ', last_name) as employee_name,
    job_title,
    hire_date,
    is_active
from {{ ref('stg_employees') }}
