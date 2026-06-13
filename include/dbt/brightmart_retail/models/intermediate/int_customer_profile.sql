with customers as (select * from {{ ref('stg_customers') }}),
segments as (select * from {{ ref('stg_customer_segments') }}),
loyalty as (select * from {{ ref('stg_loyalty_accounts') }})
select
    c.customer_id,
    c.customer_code,
    c.first_name,
    c.last_name,
    concat(c.first_name, ' ', c.last_name) as full_name,
    c.gender,
    c.birth_date,
    c.email,
    c.phone,
    c.created_at,
    c.updated_at,
    c.is_active,
    c.is_invalid_email,
    s.segment_id,
    s.segment_name,
    l.loyalty_number,
    l.enrollment_date,
    l.tier as loyalty_tier,
    l.points_balance
from customers c
left join segments s on c.segment_id = s.segment_id
left join loyalty l on c.customer_id = l.customer_id
