-- Run these probes in Snowflake after loading RAW tables to confirm the intentional anomalies.
select count(*) as invalid_or_blank_customer_emails
from raw.customers
where email is null or trim(email)='' or email not like '%@%.%';

select count(*) as invalid_or_zero_sales_quantity
from raw.sales_order_items
where try_to_number(quantity) <= 0;

select count(*) as negative_discount_lines
from raw.sales_order_items
where try_to_decimal(discount_amount, 18, 2) < 0;

select count(*) as line_total_mismatches
from raw.sales_order_items
where abs(try_to_decimal(line_total,18,2) - ((try_to_number(quantity) * try_to_decimal(unit_price,18,2)) - try_to_decimal(discount_amount,18,2))) > 0.01;

select channel, count(*)
from raw.sales_orders
group by channel
order by channel;
