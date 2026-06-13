select *
from {{ ref('dq_sales_anomaly_summary') }}
order by anomaly_count desc
