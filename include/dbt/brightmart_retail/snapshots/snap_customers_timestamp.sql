{% snapshot snap_customers_timestamp %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='updated_at'
    )
}}

select
    try_to_number(customer_id) as customer_id,
    customer_code,
    first_name,
    last_name,
    email,
    segment_id,
    is_active,
    try_to_timestamp_ntz(updated_at) as updated_at
from {{ source('brightmart_raw', 'customers') }}

{% endsnapshot %}
