{% macro clean_email(column_name) -%}
    lower(nullif(trim({{ column_name }}), ''))
{%- endmacro %}
