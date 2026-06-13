with source as (
    select * from {{ source('brightmart_raw', 'employees') }}
),
renamed as (
    select
        try_to_number(nullif(trim(employee_id), '')) as employee_id,
        {{ clean_text('employee_code') }} as employee_code,
        try_to_number(nullif(trim(store_id), '')) as store_id,
        {{ clean_text('first_name') }} as first_name,
        {{ clean_text('last_name') }} as last_name,
        {{ clean_text('job_title') }} as job_title,
        try_to_date(nullif(trim(hire_date), '')) as hire_date,
        {{ to_boolean('is_active') }} as is_active
    from source
)
select * from renamed
