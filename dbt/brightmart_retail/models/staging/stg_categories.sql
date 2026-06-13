with source as (
    select * from {{ source('brightmart_raw', 'categories') }}
),
renamed as (
    select
        try_to_number(nullif(trim(category_id), '')) as category_id,
        try_to_number(nullif(trim(department_id), '')) as department_id,
        {{ clean_text('category_name') }} as category_name
    from source
)
select * from renamed
