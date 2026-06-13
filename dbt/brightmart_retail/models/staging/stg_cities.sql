with source as (
    select * from {{ source('brightmart_raw', 'cities') }}
),
renamed as (
    select
        try_to_number(nullif(trim(city_id), '')) as city_id,
        try_to_number(nullif(trim(region_id), '')) as region_id,
        {{ clean_text('city_name') }} as city_name
    from source
)
select * from renamed
