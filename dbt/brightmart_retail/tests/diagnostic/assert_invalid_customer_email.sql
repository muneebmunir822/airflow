{{ config(severity='warn') }}
select customer_id, customer_code, email
from {{ ref('stg_customers') }}
where is_invalid_email
