with source as (
    select * from {{ source('brightmart_raw', 'customer_segments') }}
),
renamed as (
    select
        try_to_number(nullif(trim(segment_id), '')) as segment_id,
        {{ clean_text('segment_name') }} as segment_name
    from source
)
select * from renamed
