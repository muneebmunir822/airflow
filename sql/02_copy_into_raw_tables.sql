-- 02_copy_into_raw_tables.sql
-- Upload CSVs to @BRIGHTMART_DB.RAW.BRIGHTMART_STAGE, then run COPY commands below.
use database BRIGHTMART_DB;
use schema RAW;

copy into addresses
from @BRIGHTMART_STAGE/addresses.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into brands
from @BRIGHTMART_STAGE/brands.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into categories
from @BRIGHTMART_STAGE/categories.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into cities
from @BRIGHTMART_STAGE/cities.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into countries
from @BRIGHTMART_STAGE/countries.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into customer_addresses
from @BRIGHTMART_STAGE/customer_addresses.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into customer_segments
from @BRIGHTMART_STAGE/customer_segments.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into customers
from @BRIGHTMART_STAGE/customers.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into departments
from @BRIGHTMART_STAGE/departments.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into employees
from @BRIGHTMART_STAGE/employees.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into inventory_transactions
from @BRIGHTMART_STAGE/inventory_transactions.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into loyalty_accounts
from @BRIGHTMART_STAGE/loyalty_accounts.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into order_statuses
from @BRIGHTMART_STAGE/order_statuses.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into payment_methods
from @BRIGHTMART_STAGE/payment_methods.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into product_cost_history
from @BRIGHTMART_STAGE/product_cost_history.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into product_price_history
from @BRIGHTMART_STAGE/product_price_history.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into products
from @BRIGHTMART_STAGE/products.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into promotion_products
from @BRIGHTMART_STAGE/promotion_products.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into promotion_types
from @BRIGHTMART_STAGE/promotion_types.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into promotions
from @BRIGHTMART_STAGE/promotions.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into purchase_order_items
from @BRIGHTMART_STAGE/purchase_order_items.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into purchase_orders
from @BRIGHTMART_STAGE/purchase_orders.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into regions
from @BRIGHTMART_STAGE/regions.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into returns
from @BRIGHTMART_STAGE/returns.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into sales_order_items
from @BRIGHTMART_STAGE/sales_order_items.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into sales_orders
from @BRIGHTMART_STAGE/sales_orders.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into stock_levels
from @BRIGHTMART_STAGE/stock_levels.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into store_formats
from @BRIGHTMART_STAGE/store_formats.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into stores
from @BRIGHTMART_STAGE/stores.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into subcategories
from @BRIGHTMART_STAGE/subcategories.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';

copy into suppliers
from @BRIGHTMART_STAGE/suppliers.csv
file_format = (format_name = CSV_FF)
on_error = 'CONTINUE';
