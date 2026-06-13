with source as (
    select * from {{ source('brightmart_raw', 'departments') }}
),
renamed as (
    select
        try_to_number(nullif(trim(department_id), '')) as department_id,
        {{ clean_text('department_name') }} as department_name
    from source
)
select * from renamed
