{% macro generate_schema_name(custom_schema_name, node) %}

    {% set default_schema = target.schema | trim %}
    {% set configured_schema = custom_schema_name | trim if custom_schema_name is not none else none %}

    {# No explicit schema config: fall back to the target schema. #}
    {% if configured_schema is none %}
        {{ default_schema }}

    {# Keep shared raw and prod schemas stable across environments. #}
    {% elif configured_schema in ['raw', 'prod'] %}
        {{ configured_schema }}

    {# In development/CI, namespace logical schemas by user/schema to avoid collisions. #}
    {% elif target.name != 'prod' %}
        {{ configured_schema }}_{{ default_schema }}

    {# In prod, use the configured schema directly. #}
    {% else %}
        {{ configured_schema }}
    {% endif %}

{% endmacro %}
