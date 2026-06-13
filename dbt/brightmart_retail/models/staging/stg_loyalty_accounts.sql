with source as (
    select * from {{ source('brightmart_raw', 'loyalty_accounts') }}
),
renamed as (
    select
        try_to_number(nullif(trim(loyalty_account_id), '')) as loyalty_account_id,
        try_to_number(nullif(trim(customer_id), '')) as customer_id,
        {{ clean_text('loyalty_number') }} as loyalty_number,
        try_to_date(nullif(trim(enrollment_date), '')) as enrollment_date,
        {{ clean_text('tier') }} as tier,
        try_to_number(nullif(trim(points_balance), '')) as points_balance
    from source
)
select * from renamed
