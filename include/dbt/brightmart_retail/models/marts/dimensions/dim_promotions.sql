with promotions as (select * from {{ ref('stg_promotions') }}),
types as (select * from {{ ref('stg_promotion_types') }})
select
    {{ dbt_utils.generate_surrogate_key(['p.promotion_id']) }} as promotion_key,
    p.promotion_id,
    p.promotion_code,
    p.promotion_name,
    t.promotion_type_name,
    p.start_date,
    p.end_date,
    p.discount_percent,
    p.discount_amount,
    p.is_active
from promotions p
left join types t on p.promotion_type_id = t.promotion_type_id
