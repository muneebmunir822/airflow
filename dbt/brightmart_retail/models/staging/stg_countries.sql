with source as (
    select * from {{ source('brightmart_raw', 'countries') }}
),
renamed as (
    select
        try_to_number(nullif(trim(country_id), '')) as country_id,
        {{ clean_text('country_code') }} as country_code,
        {{ clean_text('country_name') }} as country_name
    from source
)
select * from renamed
