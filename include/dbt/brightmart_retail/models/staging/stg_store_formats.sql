with source as (
    select * from {{ source('brightmart_raw', 'store_formats') }}
),
renamed as (
    select
        try_to_number(nullif(trim(format_id), '')) as format_id,
        {{ clean_text('format_name') }} as format_name
    from source
)
select * from renamed
