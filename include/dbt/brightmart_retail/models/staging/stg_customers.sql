with source as (
    select * from {{ source('brightmart_raw', 'customers') }}
),
cleaned as (
    select
        try_to_number(customer_id) as customer_id,
        {{ clean_text('customer_code') }} as customer_code,
        initcap({{ clean_text('first_name') }}) as first_name,
        initcap({{ clean_text('last_name') }}) as last_name,
        upper(nullif(trim(gender), '')) as gender,
        try_to_date(nullif(trim(birth_date), '')) as birth_date,
        {{ clean_email('email') }} as email,
        {{ clean_text('phone') }} as phone,
        try_to_number(segment_id) as segment_id,
        try_to_timestamp_ntz(created_at) as created_at,
        try_to_timestamp_ntz(updated_at) as updated_at,
        {{ to_boolean('is_active') }} as is_active,
        {{ clean_text('notes') }} as notes,
        case
          when email is null or trim(email) = '' then true
          when lower(trim(email)) not like '%@%.%' then true
          else false
        end as is_invalid_email
    from source
)
select * from cleaned
