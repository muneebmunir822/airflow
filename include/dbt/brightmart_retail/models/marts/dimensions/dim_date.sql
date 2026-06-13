with all_dates as (
    select order_date as date_day from {{ ref('stg_sales_orders') }}
    union all select return_date from {{ ref('stg_returns') }}
    union all select transaction_date from {{ ref('stg_inventory_transactions') }}
    union all select order_date from {{ ref('stg_purchase_orders') }}
),
bounds as (
    select min(date_day) as min_date, max(date_day) as max_date from all_dates where date_day is not null
),
spine as (
    select dateadd(day, seq4(), min_date) as date_day
    from bounds, table(generator(rowcount => 5000))
    qualify date_day <= (select max_date from bounds)
)
select
    to_number(to_char(date_day, 'YYYYMMDD')) as date_key,
    date_day,
    year(date_day) as year_number,
    quarter(date_day) as quarter_number,
    month(date_day) as month_number,
    monthname(date_day) as month_name,
    day(date_day) as day_of_month,
    dayofweek(date_day) as day_of_week_number,
    dayname(date_day) as day_name,
    weekofyear(date_day) as week_of_year,
    case when dayofweek(date_day) in (0, 6) then true else false end as is_weekend
from spine
