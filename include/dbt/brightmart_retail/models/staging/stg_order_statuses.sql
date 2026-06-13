with source as (
    select * from {{ source('brightmart_raw', 'order_statuses') }}
),
renamed as (
    select
        try_to_number(nullif(trim(status_id), '')) as status_id,
        {{ clean_text('status_name') }} as status_name
    from source
)
select * from renamed
