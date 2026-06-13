with source as (
    select * from {{ source('brightmart_raw', 'regions') }}
),
renamed as (
    select
        try_to_number(nullif(trim(region_id), '')) as region_id,
        try_to_number(nullif(trim(country_id), '')) as country_id,
        {{ clean_text('region_name') }} as region_name
    from source
)
select * from renamed
