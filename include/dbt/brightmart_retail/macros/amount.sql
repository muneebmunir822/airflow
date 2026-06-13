{% macro to_amount(column_name) -%}
    try_to_decimal(nullif(trim({{ column_name }}), ''), 18, 2)
{%- endmacro %}
